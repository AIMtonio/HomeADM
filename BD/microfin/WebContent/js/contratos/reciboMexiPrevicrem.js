pdfMake.fonts = {
	arial: {
		normal: 'arial.ttf',
		bold: 'arialbd.ttf',
		italics: 'ariali.ttf',
		bolditalics: 'arialbi.ttf'
	}
};

var documento;



function generarReciboMexi(aportacionID){
	var tipoConsulta = 4;
	var aportacionBean = {
		'aportacionID': aportacionID
	};

	aportacionesServicio.consultaRecibo(tipoConsulta, aportacionBean, function(aportacionesBean){
		if(aportacionesBean!=null){
			consultaTipoRecibo(aportacionesBean, aportacionID);
		}
	});
}


function consultaTipoRecibo(aportacionesBean, aportacionID){
	var aportacionBean = {
		'aportacionID': aportacionID
	};
	var tipoConsulta = 0;

	if(aportacionesBean.tipoRecibo == 'C')
		tipoConsulta = 1;
	if(aportacionesBean.tipoRecibo == 'I')
		tipoConsulta = 2;
	if(aportacionesBean.tipoRecibo == 'R')
		tipoConsulta = 3;

	aportacionesServicio.consultaRecibo(tipoConsulta, aportacionBean, function(aportBean){
		if(aportBean!=null){
			if(tipoConsulta == 1)
				reciboCapitaliza(aportBean);
			if(tipoConsulta == 2)
				reciboIrregular(aportBean);
			if(tipoConsulta == 3)
				reciboRegular(aportBean);
		}
	});
}


function reciboCapitaliza(aportBean){
	var repLegal = '';

	if(aportBean.tipoPersona == 'M'){
		repLegal = ' representada en este acto por ' + aportBean.representanteLegal + ',';
	}

	var documento = {
		pageMargins: [70,80,70,80],
		header: {
		
		},
		content: [
			{ columns: [
					{ text: [
								{ text: 'PREVICREM, S.A. DE C.V. SOFOM, E.N.R.\n\n', bold: true },
					],
					style: 'encabezado'
					}
				],
				margin: [20, 0, 20, 0]
			},
			{
				text: [
					{ text: aportBean.aportacionID}, '\n\n',
				],
				style: 'contenidoDerecha'
			},
			{
				text: [
					'Valor: ', { text: '$', bold: true }, { text: aportBean.monto, bold: true }, 
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true }, '\n\n',
					'Fecha de Suscripción:', { text: aportBean.fechaSuscripcion, bold: true }, '\n\n',
					'Fecha de Vencimiento:', { text: aportBean.fechaVencimiento, bold: true }, '\n\n',
					'Lugar de Emisión: ', { text: 'Monterrey, Nuevo León, Estados Unidos Mexicanos', bold: true }, '\n\n\n'
				],
				style: 'contenido'
			},
			{
				text: [
					'POR EL VALOR RECIBIDO, el suscrito, ', { text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R. ', bold: true },
					'(“La Financiera”), recibe bajo el amparo del Convenio de Aportaciones No. ', { text: aportBean.numRegistro, bold: true },
					' de ', { text: aportBean.nombreAportante, bold: true }, ' (“El Aportante”), ',
					{ text: repLegal, bold: true },
					' la suerte principal de ', 
					{ text: ' $', bold: true },
					{ text: aportBean.monto, bold: true },
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true },
					'. Esta aportación podrá ser convertida en acciones representativas del capital social o devuelta el día ',
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ')', bold: true }, ' de ',
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true }, '.\n\n',

					'La Financiera además promete pagar a El Aportante intereses sobre la cantidad de la suerte principal insoluta de este  ',
					'instrumento, a razón del ', 
					{ text: aportBean.tasaNum, bold: true }, { text: '% (', bold: true },
					{ text: aportBean.tasaLetra , bold: true }, { text: ' por ciento) ', bold: true },
					'anual, pagaderos en forma mensual al vencimiento de cada uno de los meses correspondientes. Los intereses que mensualmente ',
					'genere esta operación (menos la cantidad de ISR que las autoridades hacendarias obliguen a La Financiera a retener y enterar) ', 
					'se capitalizarán e	incrementarán la suerte principal para el cálculo de los intereses del mes inmediato posterior. La suerte ',
					'principal de éste recibo más los intereses capitalizados mensualmente podrá ser convertida en acciones representativas del ',
					'capital social o devuelta a El Aportante el día ',
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },  
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ')', bold: true }, ' de ',
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true }, '.\n\n',

					'Todas y cada una de las devoluciones bajo este Instrumento serán efectuadas a El Aportante en la ciudad de ',
					'Monterrey, Nuevo León, mediante depósito correspondiente a la Cuenta de Cobro el día en el que la devolución venza', 
					'y sea pagadera (o al siguiente día hábil si la fecha de vencimiento fuera en día inhábil).', '\n\n',

					'Cada vez que La Financiera deje de efectuar cualquier devolución o pago vencido y pagadero bajo lo establecido en este ',
					'Instrumento, La Financiera pagará a El Aportante un cargo por concepto de ', 
					{ text: 'intereses moratorios equivalente al 2% (dos por ciento) mensual ', bold: true },
					'a partir de la fecha de su vencimiento y hasta el momento de pago. Para calcular la cantidad de los intereses moratorios ',
					'devengados en un período de incumplimiento dado, la Tasa de Intereses Moratorios (expresada como un número decimal) se ',
					'dividirá entre 30 y se multiplicará por el número de días en el que la cantidad permanezca insoluta, el resultado se multiplicará ',
					'por la cantidad insoluta.', '\n\n',

					'La Financiera podrá, sin necesidad de previo aviso o consentimiento expreso del Aportante, compensar las deudas vencidas que este ',
					'último tenga para con la Financiera con las cantidades que tenga aportadas a su favor el Aportante en éste o derivado de cualquier ',
					'otro convenio, y que no hayan sido capitalizadas.', '\n\n',

					'Los siguientes términos, al ser utilizados en el presente Instrumento, tendrán los significados que se expresan a continuación:', '\n\n',

					'“Día Hábil” significará cualquier día distinto de (a) un sábado; (b) un domingo; o (c) un día en que la institución de crédito en ',
					'que se encuentre la Cuenta de Cobro, esté autorizada u obligada por ley u otras acciones gubernamentales a cerrar para la realización',
					' de sus negocios ordinarios.', '\n\n',

					'“Cuenta de Cobro” significará la cuenta abierta y mantenida por El Aportante o cualquier otra cuenta que El Aportante abra para ',
					'recibir todos y cada uno de los pagos efectuados conforme al presente Instrumento.', '\n\n\n',

					'“Tasa de Intereses Moratorios” significará lo que sea inferior entre (a) la tasa de interés máxima permitida por la ley aplicable; ',
					'y (b) una tasa anual equivalente al 24% (veinticuatro por ciento).', '\n\n',

					'Las Partes aceptan de manera irrevocable que cualquier juicio, acción o procedimiento que surgiese en relación al presente ',
					'Instrumento, deberá ser interpuesto ante cualquier tribunal local o federal en la Ciudad de Monterrey, Nuevo León, y por medio ',
					'de la suscripción y entrega de este Instrumento las Partes renuncian expresamente a cualquier excepción que tenga o tuviera en ',
					'el futuro a la competencia y jurisdicción de dichos tribunales en cualquier juicio, acción o procedimiento, e irrevocablemente ',
					'se someten en forma general e incondicional a la jurisdicción de dichos tribunales respecto a cualquiera de dichos juicios, acciones ',
					'o procedimientos.', '\n\n',

					'Nada de lo contenido en este Instrumento en forma alguna impedirá que se interponga una acción o procedimiento relativo al ',
					'presente Instrumento en los tribunales competentes de cualquier otra jurisdicción donde La Financiera o cualquiera de sus bienes ',
					'se encontrasen o estuviesen localizados.', '\n\n',

					'El presente Instrumento se considerará como hecho bajo las leyes de los Estados Unidos Mexicanos y se sujetará e interpretará de ',
					'acuerdo con dichas leyes.', '\n\n',

					'La Financiera por el presente Instrumento renuncia expresamente a cualquier diligencia, presentación, demanda, protesto o aviso ',
					'de cualquier naturaleza en relación con este Instrumento.', '\n\n',

					'La Financiera conviene en pagar cualesquiera costos y gastos en que incurra El Aportante en relación con la presentación de ',
					'cualquier demanda para el pago de las cantidades amparadas por el presente Instrumento, incluyendo, sin limitación (i) honorarios ',
					'razonables de abogados; y (ii) gastos relacionados con lo anterior.', '\n\n',

					'La falta de ejercicio por parte de El Aportante en este Instrumento de cualquiera de sus derechos al amparo del mismo, no implicará ',
					'una renuncia a dichos derechos en ese o cualquier otro caso.', '\n\n\n\n'
				]
			},
			{
				text: [
					{ text: 'EL SUSCRIPTOR', bold: true }, '\n',
					{ text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R.', bold: true }, '\n\n\n\n\n',
					{ text: '___________________________________', bold: true }, '\n',
					{ text: 'Apoderado: ', bold: true },
					{ text: aportBean.apoderado , bold: true },  '\n',
					{ text: aportBean.direccionFiscal, bold: true }
				],
				style: 'contenidoCentrado'
			}
		],
		footer: function(currentPage) {
			return {
				columns: [
					{
						text:[
							{
								text: currentPage.toString(),
							}
						],
						alignment: 'center'
					}
				]
			};
		},
		styles: {
			encabezado: {
				alignment: 'center',
				font: 'arial',
				fontSize: 14
			},
			contenido: {
				font: 'arial',
				fontSize: 10,
				alignment: 'left'
			},
			contenidoDerecha: {
				font: 'arial',
				fontSize: 10,
				alignment: 'right'
			},
			contenidoCentrado: {
				font: 'arial',
				fontSize: 10,
				alignment: 'center'
			}
		},
		defaultStyle: {
			font: 'arial',
			fontSize: 10,
			alignment: 'justify'
		}
	};
	pdfMake.createPdf(documento).open();
}



function reciboIrregular(aportBean){
	var repLegal = '';

	if(aportBean.tipoPersona == 'M'){
		repLegal = ' representada en este acto por ' + aportBean.representanteLegal + ',';
	}

	var documento = {
		pageMargins: [70,80,70,80],
		header: {
		
		},
		content: [
			{ columns: [
					{ text: [
								{ text: 'PREVICREM, S.A. DE C.V. SOFOM, E.N.R.\n\n', bold: true },
					],
					style: 'encabezado'
					}
				],
				margin: [20, 0, 20, 0]
			},
			{
				text: [
					{ text: aportBean.aportacionID}, '\n\n',
				],
				style: 'contenidoDerecha'
			},
			{
				text: [
					'Valor: ', { text: '$', bold: true }, { text: aportBean.monto, bold: true }, 
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true }, '\n\n',
					'Fecha de Suscripción:', { text: aportBean.fechaSuscripcion, bold: true }, '\n\n',
					'Fecha de Vencimiento:', { text: aportBean.fechaVencimiento, bold: true }, '\n\n',
					'Lugar de Emisión: ', { text: 'Monterrey, Nuevo León, Estados Unidos Mexicanos', bold: true }, '\n\n\n'
				],
				style: 'contenido'
			},
			{
				text: [
					'POR EL VALOR RECIBIDO, el suscrito, ', { text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R. ', bold: true },
					'(“La Financiera”), recibe bajo el amparo del Convenio de Aportaciones No. ', { text: aportBean.numRegistro, bold: true },
					' de ', { text: aportBean.nombreAportante, bold: true }, ' (“El Aportante”), ',
					{ text: repLegal, bold: true },
					' la suerte principal de ', 
					{ text: ' $', bold: true },
					{ text: aportBean.monto, bold: true },
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true },
					'. Esta aportación podrá ser convertida en acciones representativas del capital social o devuelta el día ',
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ')', bold: true }, ' de ',
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true }, '.\n\n',

					'La Financiera además promete pagar a El Aportante intereses sobre la cantidad de la suerte principal insoluta de este ',
					'instrumento, a razón del ', 
					{ text: aportBean.tasaNum, bold: true }, { text: '% (', bold: true },
					{ text: aportBean.tasaLetra , bold: true }, { text: ' por ciento) ', bold: true },
					'anual, pagaderos en forma mensual al vencimiento de cada uno de los meses correspondientes. Los intereses causados serán ',
					'pagaderos y exigibles mediante la ejecución de ', 
					{ text: aportBean.numPagos, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.numPagosLetra, bold: true },{ text: ') ', bold: true },
					'pagos mensuales consecutivos, el primero por valor de ', 
					{ text: '$', bold: true }, { text: aportBean.intBrutoPagoUNO, bold: true },
					{ text: ' (', bold: true }, { text: aportBean.intBrutoPagoUNOLetra, bold: true }, { text: ') ', bold: true },
					'y los siguientes ', 
					{ text: aportBean.numPagosRegulares, bold: true },
					{ text: ' (', bold: true },
					{ text: aportBean.numPagosRegularesLetra, bold: true },
					{ text: ') ', bold: true },
					'pagos por valor de ', 
					{ text: '$', bold: true },
					{ text: aportBean.montoIntBruto, bold: true },
					{ text: ' (', bold: true },
					{ text:aportBean.montoIntBrutoLetra, bold: true },
					{ text: ') ', bold: true },
					'cada uno, (menos la cantidad de ISR que las autoridades hacendarias obliguen a La Financiera a retener y enterar) y serán ',
					'pagaderos los días ', 
					{ text: aportBean.diaPagoInteres, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaPagoInteresLetra, bold: true }, { text: ') ', bold: true },
					'de cada mes iniciando el día ', 
					{ text: aportBean.diaPrimerPagoInteres, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaPrimerPagoInteresLetra, bold: true }, { text: ') de ', bold: true },
					{ text: aportBean.mesAnioPrimerPago, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioPrimerPagoLetra, bold: true }, { text: ') ', bold: true },
					'y el último el día ', 
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ') de ', bold: true },
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true },'.\n\n',


					'Todas y cada uno de las devoluciones o pagos bajo este instrumento serán pagados a El Aportante en la ciudad de Monterrey, ',
					'Nuevo León, mediante depósito correspondiente a la Cuenta de Cobro el día en el que la devolución o el pago venzan y sea ',
					'pagadero (o al siguiente día hábil si la fecha de vencimiento fuera en día inhábil).', '\n\n',

					'Cada vez que La Financiera deje de efectuar cualquier devolución o pago vencido y pagadero bajo este instrumento, La Financiera ',
					'pagará a El Aportante un cargo por concepto de ',
					{ text: 'intereses moratorios equivalente al 2% (dos por ciento) mensual ', bold: true },
					'a partir de la fecha de su vencimiento y hasta el momento de pago. Para calcular la cantidad de los intereses moratorios ',
					'devengados en un período de incumplimiento dado, la Tasa de Intereses Moratorios (expresada como un número decimal) se ',
					'dividirá entre 30 y se multiplicará por el número de días en el que la cantidad permanezca insoluta, el resultado se ',
					'multiplicará por la cantidad insoluta.', '\n\n',

					'La Financiera podrá, sin necesidad de previo aviso o consentimiento expreso del Aportante, compensar las deudas vencidas que ',
					'este último tenga para con la Financiera con las cantidades que tenga aportadas a su favor el Aportante en éste o derivado de ',
					'cualquier otro convenio, y que no hayan sido capitalizadas.', '\n\n',

					'Los siguientes términos, al ser utilizados en el presente instrumento, tendrán los significados que se expresan a continuación:', '\n\n',

					'“Día Hábil” significará cualquier día distinto de (a) un sábado; (b) un domingo; o (c) un día en que la institución de crédito ',
					'en que se encuentre la Cuenta de Cobro, esté autorizada u obligada por ley u otras acciones gubernamentales a cerrar para la ',
					'realización de sus negocios ordinarios.', '\n\n',

					'“Cuenta de Cobro” significará la cuenta abierta y mantenida por El Aportante o cualquier otra cuenta que El Aportante abra para ',
					'recibir todos y cada uno de los pagos efectuados conforme al presente instrumento.', '\n\n\n',

					'“Tasa de Intereses Moratorios” significará lo que sea inferior entre (a) la tasa de interés máxima permitida por la ley aplicable; ',
					'y (b) una tasa anual equivalente al 24% (veinticuatro por ciento).', '\n\n',

					'Las Partes aceptan de manera irrevocable que cualquier juicio, acción o procedimiento que surgiese en relación al presente ',
					'Instrumento, deberá ser interpuesto ante cualquier tribunal local o federal en la Ciudad de Monterrey, Nuevo León, y por medio ',
					'de la suscripción y entrega de este instrumento las Partes renuncian expresamente a cualquier excepción que tengan o tuvieran ',
					'en el futuro a la competencia y jurisdicción de dichos tribunales en cualquier juicio, acción o procedimiento, e irrevocablemente ',
					'se somete en forma general e incondicional a la jurisdicción de dichos tribunales respecto a cualquiera de dichos juicios, ',
					'acciones o procedimientos.', '\n\n',

					'Nada de lo contenido en este instrumento en forma alguna impedirá que se interponga una acción o procedimiento relativo al presente ',
					'instrumento en los tribunales competentes de cualquier otra jurisdicción donde La Financiera o cualquiera de sus bienes se encontrasen ',
					'o estuviesen localizados.', '\n\n',

					'El presente instrumento se considerará como hecho bajo las leyes de los Estados Unidos Mexicanos y se sujetará e interpretará de ',
					'acuerdo con dichas leyes.', '\n\n',

					'La Financiera por el presente instrumento renuncia expresamente a cualquier diligencia, presentación, demanda, protesto o aviso de ',
					'cualquier naturaleza en relación con este instrumento.', '\n\n',

					'La Financiera conviene en pagar cualesquiera costos y gastos en que incurra El Aportante en relación con la presentación de ',
					'cualquier demanda para el pago de las cantidades amparadas por el presente Pagaré, incluyendo, sin limitación (i) honorarios ',
					'razonables de abogados; y (ii) gastos relacionados con lo anterior.', '\n\n',

					'La falta de ejercicio por parte de El Aportante de este instrumento de cualquiera de sus derechos al amparo del mismo, no implicará ',
					'una renuncia a dichos derechos en ese o cualquier otro caso.', '\n\n\n\n'
				]
			},
			{
				text: [
					{ text: 'EL SUSCRIPTOR', bold: true }, '\n',
					{ text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R.', bold: true }, '\n\n\n\n\n',
					{ text: '___________________________________', bold: true }, '\n',
					{ text: 'Apoderado: ', bold: true },
					{ text: aportBean.apoderado , bold: true },  '\n',
					{ text: aportBean.direccionFiscal, bold: true }
				],
				style: 'contenidoCentrado'
			}
		],
		footer: function(currentPage) {
			return {
				columns: [
					{
						text:[
							{
								text: currentPage.toString(),
							}
						],
						alignment: 'center'
					}
				]
			};
		},
		styles: {
			encabezado: {
				alignment: 'center',
				font: 'arial',
				fontSize: 14
			},
			contenido: {
				font: 'arial',
				fontSize: 10,
				alignment: 'left'
			},
			contenidoDerecha: {
				font: 'arial',
				fontSize: 10,
				alignment: 'right'
			},
			contenidoCentrado: {
				font: 'arial',
				fontSize: 10,
				alignment: 'center'
			}
		},
		defaultStyle: {
			font: 'arial',
			fontSize: 10,
			alignment: 'justify'
		}
	};
	pdfMake.createPdf(documento).open();
}



function reciboRegular(aportBean){
	var repLegal = '';

	if(aportBean.tipoPersona == 'M'){
		repLegal = ' representada en este acto por ' + aportBean.representanteLegal + ',';
	}

	var documento = {
		pageMargins: [70,80,70,80],
		
		header: {
		
		},
		content: [
			{ columns: [
					{ text: [
								{ text: 'PREVICREM, S.A. DE C.V. SOFOM, E.N.R.\n\n', bold: true },
					],
					style: 'encabezado'
					}
				],
				margin: [20, 0, 20, 0]
			},
			{
				text: [
					{ text: aportBean.aportacionID}, '\n\n',
				],
				style: 'contenidoDerecha'
			},
			{
				text: [
					'Valor: ', { text: '$', bold: true }, { text: aportBean.monto, bold: true },
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true }, '\n\n',
					'Fecha de Suscripción:', { text: aportBean.fechaSuscripcion, bold: true }, '\n\n',
					'Fecha de Vencimiento:', { text: aportBean.fechaVencimiento, bold: true }, '\n\n',
					'Lugar de Emisión: ', { text: 'Monterrey, Nuevo León, Estados Unidos Mexicanos', bold: true }, '\n\n\n'
				],
				style: 'contenido'
			},
			{
				text: [
					'POR EL VALOR RECIBIDO, el suscrito, ', { text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R. ', bold: true },
					'(“La Financiera”), recibe bajo el amparo del Convenio de Aportaciones No. ', { text: aportBean.numRegistro, bold: true },
					' de ', { text: aportBean.nombreAportante, bold: true }, ' (“El Aportante”), ',
					{ text: repLegal, bold: true },
					' la suerte principal de ', 
					{ text: ' $', bold: true },
					{ text: aportBean.monto, bold: true },
					{ text: ' (', bold: true },{ text: aportBean.montoLetra, bold: true }, { text: ')', bold: true },
					'. Esta aportación podrá ser convertida en acciones representativas del capital social o devuelta el día ',
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ')', bold: true }, ' de ',
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true }, '.\n\n',
					
					'La Financiera, además promete pagar a El Aportante intereses sobre la cantidad de la suerte principal insoluta de este instrumento, ',
					'a razón del ',
					{ text: aportBean.tasaNum, bold: true }, { text: '% (', bold: true },
					{ text: aportBean.tasaLetra , bold: true }, { text: ' por ciento) ', bold: true },
					'anual y pagaderos en forma mensual al vencimiento de cada mes. Los intereses causados serán pagaderos y exigibles mediante la ',
					'ejecución de ',
					{ text: aportBean.numPagos, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.numPagosLetra, bold: true },{ text: ') ', bold: true },
					'pagos mensuales consecutivos por valor de ',
					{ text: '$', bold: true }, { text: aportBean.intBrutoPagoUNO, bold: true },
					{ text: ' (', bold: true }, { text: aportBean.intBrutoPagoUNOLetra, bold: true }, { text: ') ', bold: true },
					'cada uno, (menos la cantidad de ISR que las autoridades hacendarias ',
					'obliguen a La Financiera a retener y enterar) y serán pagaderos los días ',
					{ text: aportBean.diaPagoInteres, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaPagoInteresLetra, bold: true }, { text: ') ', bold: true },
					' de cada mes iniciando el día ',
					{ text: aportBean.diaPrimerPagoInteres, bold: true }, { text: '( ', bold: true },
					{ text: aportBean.diaPrimerPagoInteresLetra, bold: true }, { text: ') de ', bold: true },
					{ text: aportBean.mesAnioPrimerPago, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioPrimerPagoLetra, bold: true }, { text: ') ', bold: true },
					'y el último el día ',
					{ text: aportBean.diaVencimNum, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.diaVencimLetra, bold: true }, { text: ') de ', bold: true },
					{ text: aportBean.mesAnioVencimLetra, bold: true }, { text: ' (', bold: true },
					{ text: aportBean.anioVencimLetra, bold: true }, { text: ')', bold: true },'.\n\n',

					'Todos y cada una de las devoluciones y/o pagos bajo este instrumento serán efectuados a El Aportante en la ciudad de Monterrey, ',
					'Nuevo León, mediante depósito correspondiente a la Cuenta de Cobro el día en que la devolución o el pago venzan y sea pagadero ',
					'(o al siguiente día hábil si la fecha de vencimiento fuera en día inhábil).', '\n\n',

					'Cada vez que La Financiera deje de efectuar cualquier devolución o pago vencido y pagadero bajo lo establecido en este instrumento, ',
					'La Financiera pagará a El Aportante un cargo por concepto de ', 
					{ text: 'intereses moratorios equivalente al 2% (dos por ciento) mensual ', bold: true },
					'a partir de la fecha de su vencimiento y hasta el momento de pago. Para calcular la cantidad de los intereses moratorios ',
					'devengados en un período de incumplimiento dado, la Tasa de Intereses Moratorios (expresada como un número decimal) se dividirá ',
					'entre 30 y se multiplicará por el número de días en el que la cantidad permanezca insoluta, el resultado se multiplicará por la ',
					'cantidad insoluta.', '\n\n',

					'La Financiera podrá, sin necesidad de previo aviso o consentimiento expreso del Aportante, compensar las deudas vencidas que ',
					'este último tenga para con la Financiera con las cantidades que tenga aportadas a su favor el Aportante en éste o derivado de ',
					'cualquier otro convenio, y que no hayan sido capitalizadas.', '\n\n',

					'Los siguientes términos, al ser utilizados en el presente instrumento, tendrán los significados que se expresan a continuación:', '\n\n',

					'“Día Hábil” significará cualquier día distinto de (a) un sábado; (b) un domingo; o (c) un día en que la institución de crédito en ',
					'que se encuentre la Cuenta de Cobro, esté autorizada u obligada por ley u otras acciones gubernamentales a cerrar para la ',
					'realización de sus negocios ordinarios.', '\n\n',

					'“Cuenta de Cobro” significará la cuenta abierta y mantenida por El Aportante o cualquier otra cuenta que El Aportante abra para ',
					'recibir todos y cada uno de los pagos efectuados conforme al presente Instrumento.', '\n\n',

					'“Tasa de Intereses Moratorios” significará lo que sea inferior entre (a) la tasa de interés máxima permitida por la ley aplicable; ',
					'y (b) una tasa anual equivalente al 24% (veinticuatro por ciento).', '\n\n',

					'Las Partes aceptan de manera irrevocable que cualquier juicio, acción o procedimiento que surgiese en relación al presente ',
					'instrumento, deberá ser interpuesto ante cualquier tribunal local o federal en la Ciudad de Monterrey, Nuevo León, y por medio ',
					'de la suscripción y entrega de este instrumento las Partes renuncian expresamente a cualquier excepción que tenga o tuviera ',
					'en el futuro a la competencia y jurisdicción de dichos tribunales en cualquier juicio, acción o procedimiento, e ',
					'irrevocablemente se somete en forma general e incondicional a la jurisdicción de dichos tribunales respecto a cualquiera de ',
					'dichos juicios, acciones o procedimientos.', '\n\n',

					'Nada de lo contenido en este instrumento en forma alguna impedirá que se interponga una acción o procedimiento relativo al ',
					'presente instrumento en los tribunales competentes de cualquier otra jurisdicción donde La Financiera o cualquiera de sus ',
					'bienes se encontrasen o estuviesen localizados.', '\n\n',

					'El presente instrumento se considerará como hecho bajo las leyes de los Estados Unidos Mexicanos y se sujetará e interpretará ',
					'de acuerdo con dichas leyes.', '\n\n',

					'La Financiera por el presente instrumento renuncia expresamente a cualquier diligencia, presentación, demanda, protesto o aviso ',
					'de cualquier naturaleza en relación con este instrumento.', '\n\n',

					'La Financiera conviene en pagar cualesquiera costos y gastos en que incurra El Aportante en relación con la presentación de ',
					'cualquier demanda para el pago de las cantidades amparadas por el presente instrumento, incluyendo, sin limitación (i) ',
					'honorarios razonables de abogados; y (ii) gastos relacionados con lo anterior.' , '\n\n',

					'La falta de ejercicio por parte de El Aportante en este instrumento de cualquiera de sus derechos al amparo del mismo, no ',
					'implicará una renuncia a dichos derechos en ese o cualquier otro caso.', '\n\n\n\n'
				]
			},
			{
				text: [
					{ text: 'EL SUSCRIPTOR', bold: true }, '\n',
					{ text: 'PREVICREM, S.A. DE C.V., SOFOM, E.N.R.', bold: true }, '\n\n\n\n\n',
					{ text: '___________________________________', bold: true }, '\n',
					{ text: 'Apoderado: ', bold: true },
					{ text: aportBean.apoderado , bold: true },  '\n',
					{ text: aportBean.direccionFiscal, bold: true }
				],
				style: 'contenidoCentrado'
			}
		],
		footer: function(currentPage) {
			return {
				columns: [
					{
						text:[
							{
								text: currentPage.toString(),
							}
						],
						alignment: 'center'
					}
				]
			};
		},
		
		styles: {
			encabezado: {
				alignment: 'center',
				font: 'arial',
				fontSize: 14
			},
			contenido: {
				font: 'arial',
				fontSize: 10,
				alignment: 'left'
			},
			contenidoDerecha: {
				font: 'arial',
				fontSize: 10,
				alignment: 'right'
			},
			contenidoCentrado: {
				font: 'arial',
				fontSize: 10,
				alignment: 'center'
			}
		},
		defaultStyle: {
			font: 'arial',
			fontSize: 10,
			alignment: 'justify'
		}
	};
	pdfMake.createPdf(documento).open();
}