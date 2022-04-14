pdfMake.fonts = {
	arial: {
		normal: 'arial.ttf',
		bold: 'arialbd.ttf',
		italics: 'ariali.ttf',
		bolditalics: 'arialbi.ttf'
	},
	calibri: {
		normal: 'calibri.ttf',
		bold: 'calibrib.ttf',
		italics: 'calibrii.ttf',
		bolditalics: 'calibril.ttf'
	}
};

var documento;

var contratoIndividual = 1;

var listaIntegrantes = 15;
var generales = [];
var listaAvales = [];

function generarPagareMicrocredito(creditoID,  fechaEmision) {
							
	var credito = {
		'creditoID': creditoID
	};
	pagareCreditoIndivServicio.consulta(contratoIndividual,  credito,{ async: false, callback:function(contrato){
		generales = contrato[0];
		listaAvales = contrato[1];

	}});			

	var documento = {
		pageMargins: [45,60,45,65],
		header: {
		columns: [
			{ stack: [
			'ID Crédito: ' + creditoID,
				],
				alignment: 'right',
				margin: [35, 25, 25, 0]
			},
			]
		},
		content: [
			{ columns: [

					{ text: [
								{ text: 'PAGARÉ ÚNICO\n', bold: true },
					],
					style: 'header'
					}
				],
				margin: [20, 0, 20, 0]
			},
			{ table: {
				widths: [175, '*'],
				body: [
					[
						{ text: 'Importe del Pagaré:', bold: true },
						{ text: generales[0].monto, bold: true },
					],				
					[
						{ text:'Vencimiento:', bold: true },
						{ text:generales[0].fechaVencimiento, bold: true },
					],
					[
						{ text:'Lugar de expedición:', bold: true },
						{ text:generales[0].lugarExpedicion, bold: true },
					],
					[
						{ text:'Fecha de Expedición:', bold: true },
						{ text:generales[0].fechaExpedicion, bold: true },
					],
					[
						{ text:'Plazo:', bold: true },
						{ text:generales[0].plazo, bold: true },
					],
					[
						{ text:'Tasa de Interés Ordinaria mensual:', bold: true },
						{ text:( generales[0].interesOrdinario + "por ciento más I.V.A.") ,bold: true },
					],
					[
						{ text:'Documento', bold: true },
						{ text: '1/1', bold: true },
					],
					
				]
				},
				margin: [0, 20, 0, 0]
			},
			{ text: '\n\n'},
			{
				text: [
					'Por el presente declaro deber y me obligo a pagar incondicionalmente a la orden de ',
					{ text: 'CONSOL NEGOCIOS SA DE CV SOFOM ENR', bold: true },
					', en el domicilio establecido en JUÁREZ NORTE NO.6 COL. CENTRO, TLAJOMULCO DE ZÚÑIGA, JALISCO C.P. 45640 o en cualquier otro que se me señale, la cantidad de ',
					{ text: generales[0].monto, bold: true },
					' cantidad en efectivo que he recibido a mi entera satisfacción. \n\n',
					'El saldo insoluto del presente ',
					{ text: ' PAGARÉ', bold: true },
					' causara una Tasa de Interés ORDINARIO ',
					{ text: generales[0].interesOrdinario, bold: true },	
					{ text: ' por ciento mensual, más el impuesto al valor agregado correspondiente, y en el supuesto que no realice los pagos en las fechas pactadas, causara una Tasa de Interés MORATORIO a razón de multiplicar por dos la tasa de interés mensual pactada por el capital de cada amortización vencida por el número de días transcurridos dividido entre 360 días más el impuesto al valor agregado correspondiente; conceptos que serán pagados en cada una de las fechas pactadas de conformidad con el siguiente calendario de pagos:', style : 'defaultStyle' },
					
				],
			},
			
			{ text: '\n\n'},
			{ text: 'CALENDARIO DE PAGOS\n',
				bold: true,
				style: 'header'
			},
			{
				table: {
					widths: [50, 120,70,70,70,70],

					body: crearTablaAmortizacion(generales)
				}
			},
			{ text: '\n'},
			{
				text: [
					{ text: 'NOTA: ', bold: true, style : 'small' },
					{ text: 'En caso de que la amortización coincida con día inhábil se deberá realizar el pago el día inmediato anterior.', style : 'small'	}		
				],
			},
			{ text: '\n\n'},
		
			{
				text: [
					'Acepto expresamente que, a la falta de pago o incumplimiento de alguno de los pagos pactados en el citado calendario de pagos, podrá darse por vencido anticipadamente este ',
					{ text: 'PAGARÉ ', bold: true },
					'y las cantidades insolutas pendientes de vencimiento, pudiendo el beneficiario exigir el saldo insoluto. En el supuesto de verificar pagos parciales, estos se aplicaran en el orden siguiente, a los gastos y costas judiciales, impuestos, honorarios, comisiones pendientes de cobro, intereses moratorios, intereses ordinarios y finalmente a capital. \n\n',
					'El deudor, se obliga por el importe total de este ',
					{ text: 'PAGARÉ', bold: true },
					', así como los gastos y costas, honorarios e impuestos correspondientes en caso de incumplimiento en el pago del presente',
					{ text: ' PAGARÉ', bold: true },
					', sometiéndose expresamente  a la jurisdicción y competencia de los tribunales de Tlajomulco de Zúñiga y/o de la ciudad de Guadalajara, Jalisco, pudiendo optar de conformidad con la jurisdicción concurrente el fuero local o federal para dirimir cualquier controversia derivada del presente',
					{ text: ' PAGARÉ', bold: true },
					', renunciando clara y terminantemente al fuero que la ley concede.'
				
					
				],
			},

			{ text: '\n\n'},
			{
				stack: [
					'“EL DEUDOR”',
					'\n',
					'\n',
					'___________________________________',
					generales[0].nombreCliente,
					{text:generales[0].domicilioCliente,bold:false}
				],
				bold: true,
				alignment: 'center'
			},
			{
				
				stack: [
							'\n\n\n',
							{ text:'“LOS AVALES”', bold: true },
							{ text:'ACEPTAMOS:', bold: true },
				
				        	firmantesAvales(listaAvales)
				        ],
				alignment: 'center'

				
			},
			
		],
		styles: {
			header: {
				alignment: 'center'
			},
			small: {
				font: 'arial',
				fontSize: 8,
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

function crearTablaAmortizacion(amortizaciones) {
	var tablaAmortizaciones = [
		[{ text: 'No. Cuota', bold: true, style: 'header'}, { text: 'Fecha de Vencimiento', bold: true, style: 'header'}, { text: 'Capital', bold: true, style: 'header'},{ text: 'Intereses', bold: true, style: 'header'},{ text: 'I.V.A.', bold: true, style: 'header'},{ text: 'Total', bold: true, style: 'header'}]
	];

	amortizaciones.forEach(function(amortizacion) {
		tablaAmortizaciones.push([{ text: amortizacion.amortizacionID, alignment: 'center'},
								amortizacion.fechaVencimientoCuota,
								{ text: amortizacion.capital, alignment: 'right'},
								{ text: amortizacion.interes, alignment: 'right'},
								{ text: amortizacion.ivaInteres, alignment: 'right'},
								{ text: amortizacion.montoCuota, alignment: 'right'},
							]);
	});
	return tablaAmortizaciones;
};


function firmantesAvales(integrantes) {
	var firmas = [];
	var longitud = integrantes;
	if(longitud != null){
		for (i=0, len = integrantes.length; i < len; i=i+2) {
			segundaColumna = (i + 1 < len) ? { stack: [
												 '\n',
												 '\n',
												 '_____________________________',
												 { text: integrantes[i + 1].nombre, bold:true},
												 integrantes[i + 1].domicilio
											   ]
											   } : ' ';
		   firmas.push({
			   columns: [
				   { stack: [
						 '\n',
						 '\n',
						 '_____________________________',
						 { text: integrantes[i].nombre, bold:true},
						 integrantes[i].domicilio
					 ]
				   },
				   segundaColumna
			   ]
		   });
	   }
	}

	return firmas;
}


var formulaInteres = 'data:image/png;base64,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';

