// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract YearsToUnix {

    uint yearInSec = 31536000;
    uint monthInSec = 2629743;
    uint dayInSec = 86400;
    uint hourInSec = 3600;
    uint minInSec = 60;
  //  uint GMT = 64314;
    uint addEach = 86400;


    function _doTheMath(uint _year, uint _month, uint _day, uint _hour, uint _min, uint _sec) internal view returns(uint) {
        require(_year >= 1970);
        uint yearDif = (_year - 1970) * yearInSec;
        uint monthDif = (_month - 1) * monthInSec;
        uint dayDif = (_day - 1 ) * dayInSec;
        uint hourDif = (_hour) * hourInSec;
        uint minDif = (_min) * minInSec;
        uint finalSeconds = _sec;

        return yearDif + monthDif + dayDif + hourDif + minDif + finalSeconds;
    }

    function getTimeInUnix(uint _year, uint _month, uint _day, uint _hour, uint _min, uint _sec) public view returns(uint){ // works perfectly in sync with https://www.epochconverter.com/ 
        uint cleanNum = _doTheMath(_year, _month, _day, _hour, _min, _sec);
        if (_year > 1973) {
            uint difference =  _year - 1969;
            uint bigDifference = difference * 1e10;
            uint divideByFour = bigDifference / 4;
            if(numDigits(divideByFour) >= 11){
                uint multBy = getFirstDigit(divideByFour);
                return (addEach * multBy) + _doTheMath(_year, _month, _day, _hour, _min, _sec);
            } else {
                return _doTheMath(_year, _month, _day, _hour, _min, _sec) + addEach;
            }
        } 
        
        else {
            return _doTheMath(_year, _month, _day, _hour, _min, _sec);
        }
    }

    // helper
    function getFirstDigit(uint256 n) public pure returns(uint256) {

        // If n = 654321, then we see it has 6 digits, which log10(123456) = 6
        // 10 ** (6 - 1) = 100000
        // 654321 / 100000 = 6

        uint256 countOfDigits = log10(n);
        return n / (10 ** (countOfDigits - 1));
    }

    function test(uint n) public pure returns(uint) {
        return log10(n);
    }

    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result + 1;  // take away the +1 if u want the first 2 digits 
    }

    function numDigits(uint number) public pure returns (uint) {
    uint digits = 0;
    //if (number < 0) digits = 1; // enable this line if '-' counts as a digit
    while (number != 0) {
        number /= 10;
        digits++;
    }
    return digits;
}

    function alternative(uint _year, uint _month, uint _day, uint _hour, uint _min, uint _sec) public view returns(uint) {
        uint yearDif = (_year) * yearInSec;
        uint monthDif = (_month - 1) * monthInSec;
        uint dayDif = (_day - 1 ) * dayInSec;
        uint hourDif = (_hour - 1) * hourInSec;
        uint minDif = (_min - 1) * minInSec;
        uint finalSeconds = _sec;
        uint big = 1970 * yearInSec;
        return (yearDif + monthDif + dayDif + hourDif + minDif + finalSeconds) - big;
    }

}