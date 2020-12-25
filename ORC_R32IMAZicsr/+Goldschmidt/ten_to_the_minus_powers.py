#################################################################################
# BSD 3-Clause License
# 
# Copyright (c) 2020, Jose R. Garcia
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#################################################################################
# File name     : ten_to_the_minus_powers.py
# Author        : Jose R Garcia
# Created       : 2020/12/23 16:37:58
# Last modified : 2020/12/23 17:07:21
# Project Name  : ORCs
# Module Name   : ten_to_the_minus_powers
# Description   : ORC_R32I Test Library
#
# Additional Comments:
#   Contains the test base and tests.
#################################################################################

def write_binary_to_file(binary_list):
    f = open('dhry.hex', 'r+')
    hex_inst_list = [line.split(' ') for line in f.readlines()]
    #f'{6:08b}'
    self.hex_instructions = []
    for i,s in enumerate(hex_inst_list):
        self.hex_instructions.append([i.strip() for i in s])

def generate_binary_constants(bytes_in_factor):
    binary_list = []

    for i in range(bytes_in_factor-1):
        binary_list.append(1/(10**(i+1)))
    # bin(n).replace("0b", "")
