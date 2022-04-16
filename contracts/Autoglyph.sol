pragma solidity ^0.8.7;

import "hardhat/console.sol";
contract Autoglyphs {

    int constant ONE = int(0x100000000);
    uint constant USIZE = 64;
    int constant SIZE = int(USIZE);
    int constant HALF_SIZE = SIZE / int(2);

    int constant SCALE = int(0x1b81a81ab1a81a823);
    int constant HALF_SCALE = SCALE / int(2);

    bytes prefix = "data:text/plain;charset=utf-8,";

    function draw(uint seed) public view returns (string memory) {
        uint a = uint(uint160(uint256(keccak256(abi.encodePacked(seed)))));
        uint8 scheme = getScheme(a);
        //64行，64列。每一行末尾还有3个特殊字符，表示换行。
        bytes memory output = new bytes(USIZE * (USIZE + 3) + 30);
        uint c;
        for (c = 0; c < 30; c++) {
            output[c] = prefix[c];
        }
        
        // 根据Scheme确定符号
        bytes5 symbols = getSymbol(scheme);

        int x = 0;
        int y = 0;
        uint v = 0;
        uint value = 0;
        uint mod = (a % 11) + 5;//控制稀疏程度

        //Size表示一条边
        console.log("a%3=", a%3);
        console.log("a%2=", a%2);
        unchecked {
            for (int i = int(0); i < SIZE; i++) {
                //计算y：通过坐标i，得到y
                //i to y
                y = (2 * (i - HALF_SIZE) + 1);
                //控制Y轴对称。如果a % 3 == 2，则x相同情况下，得到的y也一样。所以最后的元素值也一样。
                if (a % 3 == 1) {
                    y = -y;
                } else if (a % 3 == 2) {
                    y = abs(y);
                }
                y = y * int(a);
                //列
                for (int j = int(0); j < SIZE; j++) {
                    //计算x: 控制位置对称
                    x = (2 * (j - HALF_SIZE) + 1);
                    //控制元素对称。如果a为1，就进行横轴对称，让符号一样。如果a为0，就进行x轴反对称，让元素可能一样，也可能不一样。
                    if (a % 2 == 1) {
                        x = abs(x);
                    }
                    x = x * int(a);
                    //通过x, y，还有前文的mod，计算得到v
                    //why one
                    v = uint(x * y / ONE) % mod;
                    
        
                    //计算v，决定得到的是空格还是符号，以便得到value
                    if (v < 5) {
                        value = uint256(uint8(symbols[v]));
                    } else {
                        value = 0x2E;
                    }
                    //关键是这里。value是最终要填入的符号
                    //取value最右边的8字节，注意byte的截断是取最左边。
                    output[c] = bytes1(bytes32(value << 248));
                    c++;
                }
                //一次性写入3个字符？
                output[c] = bytes1(0x25);
                c++;
                output[c] = bytes1(0x30);
                c++;
                output[c] = bytes1(0x41);
                c++;
            }
        }
        string memory result = string(output);
        return result;
    }

    function getSymbol(uint8 scheme) internal pure returns(bytes5 symbols){
        if (scheme == 0) {
            revert();
        } else if (scheme == 1) {
            symbols = 0x2E582F5C2E; // X/\    //0x2e是空格，58是X，2F是/，5C是\
        } else if (scheme == 2) {
            symbols = 0x2E2B2D7C2E; // +-|
        } else if (scheme == 3) {
            symbols = 0x2E2F5C2E2E; // /\
        } else if (scheme == 4) {
            symbols = 0x2E5C7C2D2F; // \|-/
        } else if (scheme == 5) {
            symbols = 0x2E4F7C2D2E; // O|-
        } else if (scheme == 6) {
            symbols = 0x2E5C5C2E2E; // \
        } else if (scheme == 7) {
            symbols = 0x2E237C2D2B; // #|-+
        } else if (scheme == 8) {
            symbols = 0x2E4F4F2E2E; // OO
        } else if (scheme == 9) {
            symbols = 0x2E232E2E2E; // #
        } else {
            symbols = 0x2E234F2E2E; // #O
        }
    }

    function abs(int n) internal pure returns (int) {
        if (n >= 0) return n;
        return -n;
    }

    function getScheme(uint a) internal pure returns (uint8) {
        uint index = a % 83;
        uint8 scheme;
        if (index < 20) {
            scheme = 1;
        } else if (index < 35) {
            scheme = 2;
        } else if (index < 48) {
            scheme = 3;
        } else if (index < 59) {
            scheme = 4;
        } else if (index < 68) {
            scheme = 5;
        } else if (index < 73) {
            scheme = 6;
        } else if (index < 77) {
            scheme = 7;
        } else if (index < 80) {
            scheme = 8;
        } else if (index < 82) {
            scheme = 9;
        } else {
            scheme = 10;
        }
        return scheme;
    }
}