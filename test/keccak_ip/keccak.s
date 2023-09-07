riscv32-unknown-elf-objdump  -d /home/alessandra.dolmeta/pulpissimo_keccak/test/keccak_ip/build/keccak/keccak

/home/alessandra.dolmeta/pulpissimo_keccak/test/keccak_ip/build/keccak/keccak:     file format elf32-littleriscv


Disassembly of section .vectors:

1c008000 <__irq_vector_base>:
1c008000:	5aa0006f          	j	1c0085aa <__rt_handle_illegal_instr>
1c008004:	0840006f          	j	1c008088 <pos_no_irq_handler>
1c008008:	0800006f          	j	1c008088 <pos_no_irq_handler>
1c00800c:	07c0006f          	j	1c008088 <pos_no_irq_handler>
1c008010:	0780006f          	j	1c008088 <pos_no_irq_handler>
1c008014:	0740006f          	j	1c008088 <pos_no_irq_handler>
1c008018:	0700006f          	j	1c008088 <pos_no_irq_handler>
1c00801c:	06c0006f          	j	1c008088 <pos_no_irq_handler>
1c008020:	0680006f          	j	1c008088 <pos_no_irq_handler>
1c008024:	0640006f          	j	1c008088 <pos_no_irq_handler>
1c008028:	0600006f          	j	1c008088 <pos_no_irq_handler>
1c00802c:	05c0006f          	j	1c008088 <pos_no_irq_handler>
1c008030:	0580006f          	j	1c008088 <pos_no_irq_handler>
1c008034:	0540006f          	j	1c008088 <pos_no_irq_handler>
1c008038:	0500006f          	j	1c008088 <pos_no_irq_handler>
1c00803c:	04c0006f          	j	1c008088 <pos_no_irq_handler>
1c008040:	0480006f          	j	1c008088 <pos_no_irq_handler>
1c008044:	0440006f          	j	1c008088 <pos_no_irq_handler>
1c008048:	0400006f          	j	1c008088 <pos_no_irq_handler>
1c00804c:	03c0006f          	j	1c008088 <pos_no_irq_handler>
1c008050:	0380006f          	j	1c008088 <pos_no_irq_handler>
1c008054:	0340006f          	j	1c008088 <pos_no_irq_handler>
1c008058:	0300006f          	j	1c008088 <pos_no_irq_handler>
1c00805c:	02c0006f          	j	1c008088 <pos_no_irq_handler>
1c008060:	0280006f          	j	1c008088 <pos_no_irq_handler>
1c008064:	0240006f          	j	1c008088 <pos_no_irq_handler>
1c008068:	0200006f          	j	1c008088 <pos_no_irq_handler>
1c00806c:	01c0006f          	j	1c008088 <pos_no_irq_handler>
1c008070:	0180006f          	j	1c008088 <pos_no_irq_handler>
1c008074:	0140006f          	j	1c008088 <pos_no_irq_handler>
1c008078:	0100006f          	j	1c008088 <pos_no_irq_handler>
1c00807c:	00c0006f          	j	1c008088 <pos_no_irq_handler>

1c008080 <_start>:
1c008080:	0400006f          	j	1c0080c0 <_stext>

1c008084 <pos_illegal_instr>:
1c008084:	5260006f          	j	1c0085aa <__rt_handle_illegal_instr>

1c008088 <pos_no_irq_handler>:
1c008088:	30200073          	mret

1c00808c <pos_semihosting_call>:
1c00808c:	00100073          	ebreak
1c008090:	00008067          	ret

1c008094 <do_cl_boot>:
1c008094:	10200137          	lui	sp,0x10200
1c008098:	00100193          	li	gp,1
1c00809c:	00000217          	auipc	tp,0x0
1c0080a0:	fe420213          	addi	tp,tp,-28 # 1c008080 <_start>
1c0080a4:	04412023          	sw	tp,64(sp) # 10200040 <__CTOR_LIST__-0xbdfffc4>
1c0080a8:	00312423          	sw	gp,8(sp)

1c0080ac <loop>:
1c0080ac:	1a10a137          	lui	sp,0x1a10a
1c0080b0:	80010113          	addi	sp,sp,-2048 # 1a109800 <__CTOR_LIST__-0x1ef6804>
1c0080b4:	00012023          	sw	zero,0(sp)
1c0080b8:	10500073          	wfi
1c0080bc:	ff1ff06f          	j	1c0080ac <loop>

Disassembly of section .text:

1c0080c0 <_stext>:
1c0080c0:	ffffe297          	auipc	t0,0xffffe
1c0080c4:	4a028293          	addi	t0,t0,1184 # 1c006560 <pos_fll_is_on>
1c0080c8:	ffffe317          	auipc	t1,0xffffe
1c0080cc:	4bc30313          	addi	t1,t1,1212 # 1c006584 <__l2_priv0_end>
1c0080d0:	0002a023          	sw	zero,0(t0)
1c0080d4:	0291                	addi	t0,t0,4
1c0080d6:	fe62ede3          	bltu	t0,t1,1c0080d0 <_stext+0x10>
1c0080da:	ffffe117          	auipc	sp,0xffffe
1c0080de:	48610113          	addi	sp,sp,1158 # 1c006560 <pos_fll_is_on>
1c0080e2:	3de000ef          	jal	ra,1c0084c0 <pos_init_start>
1c0080e6:	00000513          	li	a0,0
1c0080ea:	00000593          	li	a1,0
1c0080ee:	00000397          	auipc	t2,0x0
1c0080f2:	06638393          	addi	t2,t2,102 # 1c008154 <main>
1c0080f6:	000380e7          	jalr	t2
1c0080fa:	842a                	mv	s0,a0
1c0080fc:	3f6000ef          	jal	ra,1c0084f2 <pos_init_stop>
1c008100:	8522                	mv	a0,s0
1c008102:	3a2000ef          	jal	ra,1c0084a4 <exit>
	...

1c008108 <__clzsi2>:
1c008108:	000107b7          	lui	a5,0x10
1c00810c:	02f57a63          	bgeu	a0,a5,1c008140 <__clzsi2+0x38>
1c008110:	0ff00793          	li	a5,255
1c008114:	00a7b7b3          	sltu	a5,a5,a0
1c008118:	00379793          	slli	a5,a5,0x3
1c00811c:	1c000737          	lui	a4,0x1c000
1c008120:	02000693          	li	a3,32
1c008124:	40f686b3          	sub	a3,a3,a5
1c008128:	00f55533          	srl	a0,a0,a5
1c00812c:	01c70793          	addi	a5,a4,28 # 1c00001c <__clz_tab>
1c008130:	00a78533          	add	a0,a5,a0
1c008134:	00054503          	lbu	a0,0(a0)
1c008138:	40a68533          	sub	a0,a3,a0
1c00813c:	00008067          	ret
1c008140:	01000737          	lui	a4,0x1000
1c008144:	01000793          	li	a5,16
1c008148:	fce56ae3          	bltu	a0,a4,1c00811c <__clzsi2+0x14>
1c00814c:	01800793          	li	a5,24
1c008150:	fcdff06f          	j	1c00811c <__clzsi2+0x14>

1c008154 <main>:
1c008154:	1c000537          	lui	a0,0x1c000
1c008158:	7125                	addi	sp,sp,-416
1c00815a:	11c50513          	addi	a0,a0,284 # 1c00011c <__clz_tab+0x100>
1c00815e:	18112e23          	sw	ra,412(sp)
1c008162:	24fd                	jal	1c008450 <puts>
1c008164:	0b800613          	li	a2,184
1c008168:	4581                	li	a1,0
1c00816a:	0808                	addi	a0,sp,16
1c00816c:	2485                	jal	1c0083cc <memset>
1c00816e:	0c800613          	li	a2,200
1c008172:	4581                	li	a1,0
1c008174:	01a8                	addi	a0,sp,200
1c008176:	2c99                	jal	1c0083cc <memset>
1c008178:	7369c7b7          	lui	a5,0x7369c
1c00817c:	66778793          	addi	a5,a5,1639 # 7369c667 <__l2_shared_end+0x5768c667>
1c008180:	c03e                	sw	a5,0(sp)
1c008182:	ec4b07b7          	lui	a5,0xec4b0
1c008186:	f5178793          	addi	a5,a5,-175 # ec4aff51 <__l2_shared_end+0xd049ff51>
1c00818a:	c23e                	sw	a5,4(sp)
1c00818c:	abbad7b7          	lui	a5,0xabbad
1c008190:	d2978793          	addi	a5,a5,-727 # abbacd29 <__l2_shared_end+0x8fb9cd29>
1c008194:	c43e                	sw	a5,8(sp)
1c008196:	47c1                	li	a5,16
1c008198:	01ac                	addi	a1,sp,200
1c00819a:	850a                	mv	a0,sp
1c00819c:	c63e                	sw	a5,12(sp)
1c00819e:	800007b7          	lui	a5,0x80000
1c0081a2:	debe                	sw	a5,124(sp)
1c0081a4:	2aa5                	jal	1c00831c <KeccakF1600_StatePermute>
1c0081a6:	1c000537          	lui	a0,0x1c000
1c0081aa:	12c50513          	addi	a0,a0,300 # 1c00012c <__clz_tab+0x110>
1c0081ae:	244d                	jal	1c008450 <puts>
1c0081b0:	19c12083          	lw	ra,412(sp)
1c0081b4:	4501                	li	a0,0
1c0081b6:	611d                	addi	sp,sp,416
1c0081b8:	8082                	ret

1c0081ba <pos_fll_init>:
1c0081ba:	1101                	addi	sp,sp,-32
1c0081bc:	1a1005b7          	lui	a1,0x1a100
1c0081c0:	c64e                	sw	s3,12(sp)
1c0081c2:	00451613          	slli	a2,a0,0x4
1c0081c6:	00458993          	addi	s3,a1,4 # 1a100004 <__CTOR_LIST__-0x1f00000>
1c0081ca:	99b2                	add	s3,s3,a2
1c0081cc:	0009a703          	lw	a4,0(s3)
1c0081d0:	ca26                	sw	s1,20(sp)
1c0081d2:	ce06                	sw	ra,28(sp)
1c0081d4:	cc22                	sw	s0,24(sp)
1c0081d6:	c84a                	sw	s2,16(sp)
1c0081d8:	c452                	sw	s4,8(sp)
1c0081da:	84aa                	mv	s1,a0
1c0081dc:	87ba                	mv	a5,a4
1c0081de:	04074763          	bltz	a4,1c00822c <pos_fll_init+0x72>
1c0081e2:	00858693          	addi	a3,a1,8
1c0081e6:	96b2                	add	a3,a3,a2
1c0081e8:	429c                	lw	a5,0(a3)
1c0081ea:	f0000537          	lui	a0,0xf0000
1c0081ee:	3ff50513          	addi	a0,a0,1023 # f00003ff <__l2_shared_end+0xd3ff03ff>
1c0081f2:	8fe9                	and	a5,a5,a0
1c0081f4:	00502537          	lui	a0,0x502
1c0081f8:	80050513          	addi	a0,a0,-2048 # 501800 <__CTOR_LIST__-0x1bafe804>
1c0081fc:	8fc9                	or	a5,a5,a0
1c0081fe:	05b1                	addi	a1,a1,12
1c008200:	c29c                	sw	a5,0(a3)
1c008202:	962e                	add	a2,a2,a1
1c008204:	4214                	lw	a3,0(a2)
1c008206:	fc0107b7          	lui	a5,0xfc010
1c00820a:	17fd                	addi	a5,a5,-1
1c00820c:	01875593          	srli	a1,a4,0x18
1c008210:	8efd                	and	a3,a3,a5
1c008212:	0c05e593          	ori	a1,a1,192
1c008216:	00871793          	slli	a5,a4,0x8
1c00821a:	014c0537          	lui	a0,0x14c0
1c00821e:	8ec9                	or	a3,a3,a0
1c008220:	05e2                	slli	a1,a1,0x18
1c008222:	83a1                	srli	a5,a5,0x8
1c008224:	c214                	sw	a3,0(a2)
1c008226:	8fcd                	or	a5,a5,a1
1c008228:	00f9a023          	sw	a5,0(s3)
1c00822c:	1c006437          	lui	s0,0x1c006
1c008230:	56440413          	addi	s0,s0,1380 # 1c006564 <pos_fll_freq>
1c008234:	00249a13          	slli	s4,s1,0x2
1c008238:	014406b3          	add	a3,s0,s4
1c00823c:	0006a903          	lw	s2,0(a3)
1c008240:	02091d63          	bnez	s2,1c00827a <pos_fll_init+0xc0>
1c008244:	83e9                	srli	a5,a5,0x1a
1c008246:	0742                	slli	a4,a4,0x10
1c008248:	8341                	srli	a4,a4,0x10
1c00824a:	8bbd                	andi	a5,a5,15
1c00824c:	073e                	slli	a4,a4,0xf
1c00824e:	17fd                	addi	a5,a5,-1
1c008250:	00f75933          	srl	s2,a4,a5
1c008254:	0126a023          	sw	s2,0(a3)
1c008258:	1c0066b7          	lui	a3,0x1c006
1c00825c:	56068693          	addi	a3,a3,1376 # 1c006560 <pos_fll_is_on>
1c008260:	96a6                	add	a3,a3,s1
1c008262:	4785                	li	a5,1
1c008264:	00f68023          	sb	a5,0(a3)
1c008268:	40f2                	lw	ra,28(sp)
1c00826a:	4462                	lw	s0,24(sp)
1c00826c:	44d2                	lw	s1,20(sp)
1c00826e:	49b2                	lw	s3,12(sp)
1c008270:	4a22                	lw	s4,8(sp)
1c008272:	854a                	mv	a0,s2
1c008274:	4942                	lw	s2,16(sp)
1c008276:	6105                	addi	sp,sp,32
1c008278:	8082                	ret
1c00827a:	854a                	mv	a0,s2
1c00827c:	3571                	jal	1c008108 <__clzsi2>
1c00827e:	1579                	addi	a0,a0,-2
1c008280:	8105                	srli	a0,a0,0x1
1c008282:	c939                	beqz	a0,1c0082d8 <pos_fll_init+0x11e>
1c008284:	fff50613          	addi	a2,a0,-1 # 14bffff <__CTOR_LIST__-0x1ab40005>
1c008288:	1c0066b7          	lui	a3,0x1c006
1c00828c:	4785                	li	a5,1
1c00828e:	00c797b3          	sll	a5,a5,a2
1c008292:	00a91733          	sll	a4,s2,a0
1c008296:	56068693          	addi	a3,a3,1376 # 1c006560 <pos_fll_is_on>
1c00829a:	7661                	lui	a2,0xffff8
1c00829c:	8e79                	and	a2,a2,a4
1c00829e:	009685b3          	add	a1,a3,s1
1c0082a2:	97b2                	add	a5,a5,a2
1c0082a4:	0005c603          	lbu	a2,0(a1)
1c0082a8:	9452                	add	s0,s0,s4
1c0082aa:	00a7d7b3          	srl	a5,a5,a0
1c0082ae:	c01c                	sw	a5,0(s0)
1c0082b0:	da45                	beqz	a2,1c008260 <pos_fll_init+0xa6>
1c0082b2:	0009a783          	lw	a5,0(s3)
1c0082b6:	833d                	srli	a4,a4,0xf
1c0082b8:	0742                	slli	a4,a4,0x10
1c0082ba:	7641                	lui	a2,0xffff0
1c0082bc:	8341                	srli	a4,a4,0x10
1c0082be:	8ff1                	and	a5,a5,a2
1c0082c0:	8fd9                	or	a5,a5,a4
1c0082c2:	0505                	addi	a0,a0,1
1c0082c4:	c4000737          	lui	a4,0xc4000
1c0082c8:	893d                	andi	a0,a0,15
1c0082ca:	177d                	addi	a4,a4,-1
1c0082cc:	056a                	slli	a0,a0,0x1a
1c0082ce:	8ff9                	and	a5,a5,a4
1c0082d0:	8d5d                	or	a0,a0,a5
1c0082d2:	00a9a023          	sw	a0,0(s3)
1c0082d6:	b769                	j	1c008260 <pos_fll_init+0xa6>
1c0082d8:	4505                	li	a0,1
1c0082da:	b76d                	j	1c008284 <pos_fll_init+0xca>

1c0082dc <pos_fll_constructor>:
1c0082dc:	1c0067b7          	lui	a5,0x1c006
1c0082e0:	56478793          	addi	a5,a5,1380 # 1c006564 <pos_fll_freq>
1c0082e4:	0007a023          	sw	zero,0(a5)
1c0082e8:	0007a223          	sw	zero,4(a5)
1c0082ec:	1c0067b7          	lui	a5,0x1c006
1c0082f0:	56079023          	sh	zero,1376(a5) # 1c006560 <pos_fll_is_on>
1c0082f4:	8082                	ret

1c0082f6 <pos_soc_init>:
1c0082f6:	1141                	addi	sp,sp,-16
1c0082f8:	c606                	sw	ra,12(sp)
1c0082fa:	c422                	sw	s0,8(sp)
1c0082fc:	37c5                	jal	1c0082dc <pos_fll_constructor>
1c0082fe:	4501                	li	a0,0
1c008300:	3d6d                	jal	1c0081ba <pos_fll_init>
1c008302:	1c006437          	lui	s0,0x1c006
1c008306:	87aa                	mv	a5,a0
1c008308:	56c40413          	addi	s0,s0,1388 # 1c00656c <pos_freq_domains>
1c00830c:	4505                	li	a0,1
1c00830e:	c01c                	sw	a5,0(s0)
1c008310:	356d                	jal	1c0081ba <pos_fll_init>
1c008312:	40b2                	lw	ra,12(sp)
1c008314:	c408                	sw	a0,8(s0)
1c008316:	4422                	lw	s0,8(sp)
1c008318:	0141                	addi	sp,sp,16
1c00831a:	8082                	ret

1c00831c <KeccakF1600_StatePermute>:
1c00831c:	1101                	addi	sp,sp,-32
1c00831e:	cc22                	sw	s0,24(sp)
1c008320:	842a                	mv	s0,a0
1c008322:	1c000537          	lui	a0,0x1c000
1c008326:	13c50513          	addi	a0,a0,316 # 1c00013c <__clz_tab+0x120>
1c00832a:	ca26                	sw	s1,20(sp)
1c00832c:	ce06                	sw	ra,28(sp)
1c00832e:	84ae                	mv	s1,a1
1c008330:	2205                	jal	1c008450 <puts>
1c008332:	1a4005b7          	lui	a1,0x1a400
1c008336:	87a2                	mv	a5,s0
1c008338:	0c840613          	addi	a2,s0,200
1c00833c:	40858533          	sub	a0,a1,s0
1c008340:	4394                	lw	a3,0(a5)
1c008342:	00f50733          	add	a4,a0,a5
1c008346:	0791                	addi	a5,a5,4
1c008348:	c314                	sw	a3,0(a4)
1c00834a:	fec79be3          	bne	a5,a2,1c008340 <KeccakF1600_StatePermute+0x24>
1c00834e:	4785                	li	a5,1
1c008350:	18f5a823          	sw	a5,400(a1) # 1a400190 <__CTOR_LIST__-0x1bffe74>
1c008354:	1a400737          	lui	a4,0x1a400
1c008358:	19472783          	lw	a5,404(a4) # 1a400194 <__CTOR_LIST__-0x1bffe70>
1c00835c:	8b85                	andi	a5,a5,1
1c00835e:	dfed                	beqz	a5,1c008358 <KeccakF1600_StatePermute+0x3c>
1c008360:	c602                	sw	zero,12(sp)
1c008362:	4732                	lw	a4,12(sp)
1c008364:	03100793          	li	a5,49
1c008368:	02e7c663          	blt	a5,a4,1c008394 <KeccakF1600_StatePermute+0x78>
1c00836c:	1a400637          	lui	a2,0x1a400
1c008370:	0c860613          	addi	a2,a2,200 # 1a4000c8 <__CTOR_LIST__-0x1bfff3c>
1c008374:	03100593          	li	a1,49
1c008378:	4732                	lw	a4,12(sp)
1c00837a:	47b2                	lw	a5,12(sp)
1c00837c:	070a                	slli	a4,a4,0x2
1c00837e:	9732                	add	a4,a4,a2
1c008380:	4314                	lw	a3,0(a4)
1c008382:	4732                	lw	a4,12(sp)
1c008384:	078a                	slli	a5,a5,0x2
1c008386:	97a6                	add	a5,a5,s1
1c008388:	0705                	addi	a4,a4,1
1c00838a:	c63a                	sw	a4,12(sp)
1c00838c:	4732                	lw	a4,12(sp)
1c00838e:	c394                	sw	a3,0(a5)
1c008390:	fee5d4e3          	bge	a1,a4,1c008378 <KeccakF1600_StatePermute+0x5c>
1c008394:	4462                	lw	s0,24(sp)
1c008396:	40f2                	lw	ra,28(sp)
1c008398:	44d2                	lw	s1,20(sp)
1c00839a:	1c000537          	lui	a0,0x1c000
1c00839e:	14c50513          	addi	a0,a0,332 # 1c00014c <__clz_tab+0x130>
1c0083a2:	6105                	addi	sp,sp,32
1c0083a4:	a075                	j	1c008450 <puts>

1c0083a6 <pos_wait_forever>:
1c0083a6:	f14027f3          	csrr	a5,mhartid
1c0083aa:	8795                	srai	a5,a5,0x5
1c0083ac:	03f7f793          	andi	a5,a5,63
1c0083b0:	477d                	li	a4,31
1c0083b2:	00e78363          	beq	a5,a4,1c0083b8 <pos_wait_forever+0x12>
1c0083b6:	a001                	j	1c0083b6 <pos_wait_forever+0x10>
1c0083b8:	1a10a7b7          	lui	a5,0x1a10a
1c0083bc:	577d                	li	a4,-1
1c0083be:	80e7a423          	sw	a4,-2040(a5) # 1a109808 <__CTOR_LIST__-0x1ef67fc>
1c0083c2:	10500073          	wfi
1c0083c6:	10500073          	wfi
1c0083ca:	bfe5                	j	1c0083c2 <pos_wait_forever+0x1c>

1c0083cc <memset>:
1c0083cc:	fff60e13          	addi	t3,a2,-1
1c0083d0:	ce25                	beqz	a2,1c008448 <memset+0x7c>
1c0083d2:	4789                	li	a5,2
1c0083d4:	0ff5f593          	andi	a1,a1,255
1c0083d8:	07c7fa63          	bgeu	a5,t3,1c00844c <memset+0x80>
1c0083dc:	00859793          	slli	a5,a1,0x8
1c0083e0:	8fcd                	or	a5,a5,a1
1c0083e2:	01059713          	slli	a4,a1,0x10
1c0083e6:	8f5d                	or	a4,a4,a5
1c0083e8:	01859693          	slli	a3,a1,0x18
1c0083ec:	8ed9                	or	a3,a3,a4
1c0083ee:	0086d313          	srli	t1,a3,0x8
1c0083f2:	0106d893          	srli	a7,a3,0x10
1c0083f6:	ffc67813          	andi	a6,a2,-4
1c0083fa:	87aa                	mv	a5,a0
1c0083fc:	982a                	add	a6,a6,a0
1c0083fe:	0ff77713          	andi	a4,a4,255
1c008402:	82e1                	srli	a3,a3,0x18
1c008404:	0ff37313          	andi	t1,t1,255
1c008408:	0ff8f893          	andi	a7,a7,255
1c00840c:	00e78023          	sb	a4,0(a5)
1c008410:	006780a3          	sb	t1,1(a5)
1c008414:	01178123          	sb	a7,2(a5)
1c008418:	00d781a3          	sb	a3,3(a5)
1c00841c:	0791                	addi	a5,a5,4
1c00841e:	ff0797e3          	bne	a5,a6,1c00840c <memset+0x40>
1c008422:	ffc67793          	andi	a5,a2,-4
1c008426:	00f50733          	add	a4,a0,a5
1c00842a:	40fe0e33          	sub	t3,t3,a5
1c00842e:	00f60e63          	beq	a2,a5,1c00844a <memset+0x7e>
1c008432:	00b70023          	sb	a1,0(a4)
1c008436:	000e0963          	beqz	t3,1c008448 <memset+0x7c>
1c00843a:	00b700a3          	sb	a1,1(a4)
1c00843e:	4785                	li	a5,1
1c008440:	00fe0463          	beq	t3,a5,1c008448 <memset+0x7c>
1c008444:	00b70123          	sb	a1,2(a4)
1c008448:	8082                	ret
1c00844a:	8082                	ret
1c00844c:	872a                	mv	a4,a0
1c00844e:	b7d5                	j	1c008432 <memset+0x66>

1c008450 <puts>:
1c008450:	00054783          	lbu	a5,0(a0)
1c008454:	c78d                	beqz	a5,1c00847e <puts+0x2e>
1c008456:	f14026f3          	csrr	a3,mhartid
1c00845a:	00369713          	slli	a4,a3,0x3
1c00845e:	1a10f637          	lui	a2,0x1a10f
1c008462:	0ff77713          	andi	a4,a4,255
1c008466:	9732                	add	a4,a4,a2
1c008468:	6609                	lui	a2,0x2
1c00846a:	068a                	slli	a3,a3,0x2
1c00846c:	f8060613          	addi	a2,a2,-128 # 1f80 <__CTOR_LIST__-0x1bffe084>
1c008470:	8ef1                	and	a3,a3,a2
1c008472:	9736                	add	a4,a4,a3
1c008474:	c31c                	sw	a5,0(a4)
1c008476:	00154783          	lbu	a5,1(a0)
1c00847a:	0505                	addi	a0,a0,1
1c00847c:	ffe5                	bnez	a5,1c008474 <puts+0x24>
1c00847e:	f1402773          	csrr	a4,mhartid
1c008482:	00371793          	slli	a5,a4,0x3
1c008486:	1a10f6b7          	lui	a3,0x1a10f
1c00848a:	0ff7f793          	andi	a5,a5,255
1c00848e:	97b6                	add	a5,a5,a3
1c008490:	6689                	lui	a3,0x2
1c008492:	f8068693          	addi	a3,a3,-128 # 1f80 <__CTOR_LIST__-0x1bffe084>
1c008496:	070a                	slli	a4,a4,0x2
1c008498:	8f75                	and	a4,a4,a3
1c00849a:	97ba                	add	a5,a5,a4
1c00849c:	4729                	li	a4,10
1c00849e:	c398                	sw	a4,0(a5)
1c0084a0:	4501                	li	a0,0
1c0084a2:	8082                	ret

1c0084a4 <exit>:
1c0084a4:	800007b7          	lui	a5,0x80000
1c0084a8:	1141                	addi	sp,sp,-16
1c0084aa:	8d5d                	or	a0,a0,a5
1c0084ac:	c606                	sw	ra,12(sp)
1c0084ae:	1a1047b7          	lui	a5,0x1a104
1c0084b2:	0aa7a023          	sw	a0,160(a5) # 1a1040a0 <__CTOR_LIST__-0x1efbf64>
1c0084b6:	3dc5                	jal	1c0083a6 <pos_wait_forever>

1c0084b8 <pos_io_start>:
1c0084b8:	4501                	li	a0,0
1c0084ba:	8082                	ret

1c0084bc <pos_io_stop>:
1c0084bc:	4501                	li	a0,0
1c0084be:	8082                	ret

1c0084c0 <pos_init_start>:
1c0084c0:	1141                	addi	sp,sp,-16
1c0084c2:	c422                	sw	s0,8(sp)
1c0084c4:	1c000437          	lui	s0,0x1c000
1c0084c8:	c606                	sw	ra,12(sp)
1c0084ca:	00840413          	addi	s0,s0,8 # 1c000008 <ctor_list>
1c0084ce:	3525                	jal	1c0082f6 <pos_soc_init>
1c0084d0:	28f1                	jal	1c0085ac <pos_irq_init>
1c0084d2:	2221                	jal	1c0085da <pos_soc_event_init>
1c0084d4:	208d                	jal	1c008536 <pos_allocs_init>
1c0084d6:	405c                	lw	a5,4(s0)
1c0084d8:	c791                	beqz	a5,1c0084e4 <pos_init_start+0x24>
1c0084da:	0411                	addi	s0,s0,4
1c0084dc:	0411                	addi	s0,s0,4
1c0084de:	9782                	jalr	a5
1c0084e0:	401c                	lw	a5,0(s0)
1c0084e2:	ffed                	bnez	a5,1c0084dc <pos_init_start+0x1c>
1c0084e4:	3fd1                	jal	1c0084b8 <pos_io_start>
1c0084e6:	300467f3          	csrrsi	a5,mstatus,8
1c0084ea:	40b2                	lw	ra,12(sp)
1c0084ec:	4422                	lw	s0,8(sp)
1c0084ee:	0141                	addi	sp,sp,16
1c0084f0:	8082                	ret

1c0084f2 <pos_init_stop>:
1c0084f2:	1141                	addi	sp,sp,-16
1c0084f4:	c422                	sw	s0,8(sp)
1c0084f6:	1c000437          	lui	s0,0x1c000
1c0084fa:	c606                	sw	ra,12(sp)
1c0084fc:	01440413          	addi	s0,s0,20 # 1c000014 <dtor_list>
1c008500:	3f75                	jal	1c0084bc <pos_io_stop>
1c008502:	405c                	lw	a5,4(s0)
1c008504:	c791                	beqz	a5,1c008510 <pos_init_stop+0x1e>
1c008506:	0411                	addi	s0,s0,4
1c008508:	0411                	addi	s0,s0,4
1c00850a:	9782                	jalr	a5
1c00850c:	401c                	lw	a5,0(s0)
1c00850e:	ffed                	bnez	a5,1c008508 <pos_init_stop+0x16>
1c008510:	40b2                	lw	ra,12(sp)
1c008512:	4422                	lw	s0,8(sp)
1c008514:	0141                	addi	sp,sp,16
1c008516:	8082                	ret

1c008518 <pos_alloc_init>:
1c008518:	00758793          	addi	a5,a1,7
1c00851c:	9be1                	andi	a5,a5,-8
1c00851e:	40b785b3          	sub	a1,a5,a1
1c008522:	c11c                	sw	a5,0(a0)
1c008524:	40b605b3          	sub	a1,a2,a1
1c008528:	00b05663          	blez	a1,1c008534 <pos_alloc_init+0x1c>
1c00852c:	99e1                	andi	a1,a1,-8
1c00852e:	c38c                	sw	a1,0(a5)
1c008530:	0007a223          	sw	zero,4(a5)
1c008534:	8082                	ret

1c008536 <pos_allocs_init>:
1c008536:	1c0065b7          	lui	a1,0x1c006
1c00853a:	1141                	addi	sp,sp,-16
1c00853c:	58458613          	addi	a2,a1,1412 # 1c006584 <__l2_priv0_end>
1c008540:	1c0087b7          	lui	a5,0x1c008
1c008544:	c606                	sw	ra,12(sp)
1c008546:	58458593          	addi	a1,a1,1412
1c00854a:	40c78633          	sub	a2,a5,a2
1c00854e:	04f5d863          	bge	a1,a5,1c00859e <pos_allocs_init+0x68>
1c008552:	1c006537          	lui	a0,0x1c006
1c008556:	57850513          	addi	a0,a0,1400 # 1c006578 <pos_alloc_l2>
1c00855a:	3f7d                	jal	1c008518 <pos_alloc_init>
1c00855c:	1c0085b7          	lui	a1,0x1c008
1c008560:	5f458613          	addi	a2,a1,1524 # 1c0085f4 <__l2_priv1_end>
1c008564:	1c0107b7          	lui	a5,0x1c010
1c008568:	5f458593          	addi	a1,a1,1524
1c00856c:	40c78633          	sub	a2,a5,a2
1c008570:	02f5da63          	bge	a1,a5,1c0085a4 <pos_allocs_init+0x6e>
1c008574:	1c006537          	lui	a0,0x1c006
1c008578:	57c50513          	addi	a0,a0,1404 # 1c00657c <pos_alloc_l2+0x4>
1c00857c:	3f71                	jal	1c008518 <pos_alloc_init>
1c00857e:	40b2                	lw	ra,12(sp)
1c008580:	1c0105b7          	lui	a1,0x1c010
1c008584:	00058793          	mv	a5,a1
1c008588:	1c080637          	lui	a2,0x1c080
1c00858c:	1c006537          	lui	a0,0x1c006
1c008590:	8e1d                	sub	a2,a2,a5
1c008592:	00058593          	mv	a1,a1
1c008596:	58050513          	addi	a0,a0,1408 # 1c006580 <pos_alloc_l2+0x8>
1c00859a:	0141                	addi	sp,sp,16
1c00859c:	bfb5                	j	1c008518 <pos_alloc_init>
1c00859e:	4581                	li	a1,0
1c0085a0:	4601                	li	a2,0
1c0085a2:	bf45                	j	1c008552 <pos_allocs_init+0x1c>
1c0085a4:	4581                	li	a1,0
1c0085a6:	4601                	li	a2,0
1c0085a8:	b7f1                	j	1c008574 <pos_allocs_init+0x3e>

1c0085aa <__rt_handle_illegal_instr>:
1c0085aa:	8082                	ret

1c0085ac <pos_irq_init>:
1c0085ac:	1a10a737          	lui	a4,0x1a10a
1c0085b0:	56fd                	li	a3,-1
1c0085b2:	f14027f3          	csrr	a5,mhartid
1c0085b6:	8795                	srai	a5,a5,0x5
1c0085b8:	80d72423          	sw	a3,-2040(a4) # 1a109808 <__CTOR_LIST__-0x1ef67fc>
1c0085bc:	03f7f793          	andi	a5,a5,63
1c0085c0:	477d                	li	a4,31
1c0085c2:	00e78363          	beq	a5,a4,1c0085c8 <pos_irq_init+0x1c>
1c0085c6:	8082                	ret
1c0085c8:	1c0087b7          	lui	a5,0x1c008
1c0085cc:	00078793          	mv	a5,a5
1c0085d0:	0017e793          	ori	a5,a5,1
1c0085d4:	30579073          	csrw	mtvec,a5
1c0085d8:	8082                	ret

1c0085da <pos_soc_event_init>:
1c0085da:	1a1067b7          	lui	a5,0x1a106
1c0085de:	577d                	li	a4,-1
1c0085e0:	c3d8                	sw	a4,4(a5)
1c0085e2:	c798                	sw	a4,8(a5)
1c0085e4:	c7d8                	sw	a4,12(a5)
1c0085e6:	cb98                	sw	a4,16(a5)
1c0085e8:	cbd8                	sw	a4,20(a5)
1c0085ea:	cf98                	sw	a4,24(a5)
1c0085ec:	cfd8                	sw	a4,28(a5)
1c0085ee:	d398                	sw	a4,32(a5)
1c0085f0:	8082                	ret

1c0085f2 <_endtext>:
	...
