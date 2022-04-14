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
var integrantes = [];
var amortizaciones = [];
var garantias = [];
var listaGarantes = [];
var listaAvales = [];
var listaUsuarios = [];
var firmas = [];


function generarContratoMicrocredito(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
						RFCInst, direccionInst, telefonoInst,
						calcInteres, fechaEmision) {

	var credito = {
		'creditoID': creditoID
	};
	contratoCreditoIndivServicio.consulta(contratoIndividual,  credito,{ async: false, callback:function(contrato){
		generales = contrato[0];
		amortizaciones = contrato[1];
		garantias = contrato[2];
		generalAvales = contrato [3];
		generalGarantes = contrato [4];
		integrantes = contrato[5];
		listaGarantes = contrato[6];
		listaAvales = contrato[7];
		listaUsuarios = contrato[8];
	}});


	var documento = {
		pageMargins: [45,60,45,65],
		footer: function(currentPage, pageCount) {
			return [
				{ text: 'Página ' + currentPage.toString() + ' de ' + pageCount, alignment: 'center' }
			  ]
			 },
		header: {
		columns: [
			{ text: 'CONTRATO DE ADHESIÓN MICROCRÉDITO CONSOL',
				alignment: 'left',
				margin: [25, 25, -35, 0]
			},
			{ stack: [
			'N° de Crédito ' + generales.creditoID,
			'RECA: ' + generales.reca
				],
				alignment: 'right',
				margin: [35, 25, 25, 0]
			},
			]
		},
		content: [
			{ columns: [
					{
					image: logoConsol,
					width: 40,
					height: 60
					},
					{ text: [
								'\n',
								'CONSOL NEGOCIOS, S.A. DE C.V. SOFOM ENR\n',
								{ text: 'SINTESIS DEL CONTRATO DE ADHESION EN CUADRO INFORMATIVO\n', bold: true },
								'El siguiente cuadro informativo forma parte integral del contrato de adhesión.'
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
						{ text: 'CAT a la fecha de contratación a tasa fija, para fines informativos y de comparación exclusivamente:', bold: true },
						{ text: generales.CAT, bold: true },
					],
					[
						{ text:'Monto de la operación:', bold: true },
						{ text:generales.montoTotal, bold: true },
					],
					[
						{ text:'Plazo:', bold: true },
						generales.plazo,
					],
					[
						{ text:'Tasa de interés anual fija ordinaria:', bold: true },
						{ text:generales.tasaOrdinaria, bold: true },
					],
					[
						{ text:'Tasa de interés moratoria Vencida:', bold: true },
						{ text:generales.tasaMoratoria, bold: true },
					],
					[
						{ text:'Comisión por administración:', bold: true },
						{ text: [generales.comisionAdmon, ' del crédito total = ', generales.montoComAdm] },
					],
					[
						{ text:'Fecha de corte:', bold: true },
						'Día último de cada mes',
					],
					[
						{ stack: [
							{text:'Seguro de vida:\n', bold: true },
							{text:'Cobertura:\n', bold: true },
							{text:'Prima cubierta por el cliente:\n', bold: true },
							{text:'Vigencia:', bold: true },
							]
						},
						{ stack: [
							'\n',
							generales.coberturaSeguro,
							generales.primaSeguro,
                            generales.vigenciaLetra + ' meses a partir de la contratación.'

						  ]
						}
					],
					[
						{text:'Beneficiario preferente:',bold: true },
						razonSocialInst,
					],
					[
						{text:'Datos de la unidad Especializada de atención a usuarios:',bold: true },
						generales.datosUEAU,
					]
				]
				},
				margin: [0, 20, 0, 0]
			},
			{
				table: {
					widths: ['*'],
					body: [
						[
							{ stack: [
								{ text: 'GARANTÍAS: Para garantizar el pago de este crédito, “EL ACREDITADO” deja en garantía el bien que se describe a continuación:', bold: true}
							]}
						],
						[
							{

								stack: [
									creaTablaGarantias(garantias, firmas)
								]


							},
						]
					]
				}
			},
			{ text: '\n\n'},
			{ text: 'TABLA DE AMORTIZACIÓN\n',
				bold: true,
				style: 'header'
			},
			{
				table: {
					widths: [65, 120,290],
					body: crearTabla(amortizaciones)
				}
			},
			{ text: '\n\n'},
			{
				stack: [
					'POR "LA ACREDITANTE"',
					'\n',
					'\n',
					'___________________________________',
					generales.nomApoderadoLegal,
					'APODERADO LEGAL'
				],
				bold: true,
				style: 'header',
			},
			{ text: '\n\n'},
			{
				stack: [
					'POR "EL ACREDITADO',
					'\n',
					'\n',
					'___________________________________',
					generales.nombreCliente,
					{text:generales.direccionCliente,bold:false}
				],
				bold: true,
				style: 'header',
				alignment: 'center',
				pageBreak: 'after'

			},

			{
				text: [
					'CONTRATO DE APERTURA DE CRÉDITO ',
					{ text: 'SIMPLE', bold: true },
					', CON GARANTÍA SOLIDARIA, PRENDARÍA, HIPOTECARIA, GARANTÍA LIQUIDA Y/O AVAL QUE CELEBRAN POR UNA PARTE LA EMPRESA DENOMINADA "',
					{ text: razonSocialInst, bold: true },
					' "COMO ACREDITANTE, A QUIEN EN LO SUCESIVO Y PARA EFECTOS DEL PRESENTE CONTRATO SE DENOMINARA',
					{ text: ' “LA ACREDITANTE“', bold: true },
					', REPRESENTADO EN ESTE ACTO POR EL C. ',
					generales.nomRepresentanteLeg,
					', EN SU CARÁCTER DE REPRESENTANTE LEGAL; Y POR LA OTRA PARTE POR SU PROPIO DERECHO EL (LA, LOS, LAS) SEÑOR (ES, AS): ',
					generales.nombreCliente,
					aliasCliente(generales.aliasCliente),
					', COMO ACREDITADO(S) (AS) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO ',
					{ text: '“EL ACREDITADO”', bold: true },
					', ASÍ MISMO COMPARECE (N): ',
					adecuarCadena(generalGarantes.cadenaGarantes),
					' COMO GARANTE(S) PRENDARIO(S) O GARANTE(S) HIPOTECARIO(S) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO',
					{ text: ' “EL GARANTE PRENDARIO(S) O GARANTE(S) HIPOTECARIO(S)”', bold: true },
					', ASÍ MISMO COMPARECE(N) EL (LOS, LAS) SEÑOR (ES, AS): ',
					adecuarCadena(generalAvales.cadenaAvales),
					' COMO EL (LOS) AVAL (ES) U OBLIGADO SOLIDARIO A QUIEN (ES) EN LO SUCESIVO SE LE (S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO ',
					{text: '“EL(LOS) (LAS) AVAL(ES) U OBLIGADO (AS) SOLIDARIO (AS)”', bold: true},
					', DE CONFORMIDAD CON LAS SIGUIENTES DECLARACIONES Y CLÁUSULAS.'
				],
			},
			{ text: '\n\n' },
			{ text: 'D E C L A R A C I O N E S', style: 'header', bold: true},
			{ text: '\n\n' },
			{
				type: 'upper-roman',
				ol: [
					[
						{ text: ['Bajo protesta de decir verdad declara “CONSOL NEGOCIOS SOCIEDAD ANÓNIMA DE CAPITAL VARIABLE SOCIEDAD FINANCIERA DE OBJETO MÚLTIPLE ENTIDAD NO REGULADA” (SOFOM ENR) por conducto de su representante legal:'] },
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								'Que es una Sociedad Anónima de Capital Variable legalmente constituida conforme a las leyes de la República Mexicana, según consta en Escritura Pública número 13,424 de fecha 05 de agosto de 2004 pasada ante la fe del Notario Público número 3 tres de la ciudad de Tlajomulco de Zúñiga, Jalisco, Licenciado Edmundo Márquez Hernández. inscrita en el Registro Público de la Propiedad y de Comercio del Estado de Jalisco con el folio mercantil Electrónico No. 23674*1, el día 17 de agosto de 2004.',
								'Que con fecha 05 (Cinco) del mes de Marzo del 2007 se cambió la denominación social de “FIRAGRO SA de CV” a “CONSOL NEGOCIOS SA de CV SOFOM ENR”, según consta en la Escritura Pública número 16,356 (Dieciséis Mil Trescientos Cincuenta y Seis) otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández, en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco e inscrita en el Registro Público de la Propiedad y de Comercio del estado de Jalisco con fecha 29 de marzo del 2007 con el folio mercantil Electrónico No. 23674*1',
							    { text: ['Las facultades con las que actúa no le han sido revocadas ni restringidas, por lo que comparece en pleno ejercicio de facultades delegadas, según costa en la Escritura Pública número 16,473 (Dieciséis Mil Cuatrocientos Setenta y tres) que contiene la aclaración de la sociedad denominada CONSOL NEGOCIOS S.A. DE C.V. SOFOM ENR, de fecha 02 (Dos) de mayo del 2007 otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández, en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco, e inscrita en el Registro Público de la Propiedad y de Comercio del Estado de Jalisco con fecha 25 de junio del 2007.']},
 								{ text: ['La personalidad con la que se actúa se acredita mediante la Escritura Pública número ' +  Intl.NumberFormat().format(dividirString(generales.numEscPub)[0]).replace(".", ",").replace(".", ",") +' ('+ formatoString(dividirString(generales.numEscPub)[1])+ ') de fecha ' + generales.fechaEscPub + ' otorgada ante la Fe del Notario Público Número ' + dividirString(generales.numNotariaPub)[0] +' ('+ formatoString(dividirString(generales.numNotariaPub)[1]) + ') de la Ciudad de '+ generales.nomMunicipioEscPub + ', ' + generales.nomEstadoEscPub + ', Lic. '+ generales.nombreNotario +' inscrita en el Registro Público de la Propiedad y de Comercio con el Folio Mercantil Electrónico No. ' + generales.folioMercantil + ' en el cual se otorga al ',
 								{ text: 'C. ' + generales.nomApoderadoLegal, bold: true },
								 ' poder amplio para Pleitos y Cobranzas, para Actos de Administración, Para Actos de Dominio, para Actos de Administración en Materia Fiscal y Laboral, y para Suscribir Títulos de Crédito.'] },
								'Que para su constitución y operación como SOCIEDAD FINANCIERA DE OBJETO MÚLTIPLE ENTIDAD NO REGULADA, no requieren de autorización de la Secretaría de Hacienda y Crédito Público.',
								'Que tiene su domicilio en calle Juárez Norte número 06 Colonia Centro, C.P. 45640, en Tlajomulco de Zúñiga, Jalisco.',
								'Que la sociedad anónima que representa tiene por objeto social entre otros, el arrendamiento y factoraje financiero, así como el otorgar financiamiento a las personas físicas o morales cuya actividad sea la producción, acopio y distribución de bienes y servicios de o para los sectores agropecuario, silvícola y pesquero; así como de la agroindustria y de otras actividades conexas o afines o que se desarrollen en el medio rural. Realizar actividades y operaciones de crédito y servicios, sin que dentro de estas actividades y de sus estados financieros se incluya la intermediación de recursos provenientes de captación directa del público o créditos de personas físicas o morales no reguladas por las autoridades financieras. ',
								'Para la realización de las operaciones señaladas no está sujeta a la supervisión y vigilancia de la Comisión Nacional Bancaria y de Valores, sino de la Comisión Nacional para la Protección y Defensa de los usuarios de Servicios Financieros (CONDUSEF).',
								'Que tiene autorización del BANCO DE MÉXICO COMO FIDUCIARIO DEL FIDEICOMISO DENOMINADO FONDO ESPECIAL PARA FINANCIAMIENTOS AGROPECUARIOS, para operar como SOFOM ENR. Para tal efecto tiene un contrato de apertura de línea de crédito con el banco de México en su carácter de fiduciario del fideicomiso denominado Fondo Especial para Financiamientos Agropecuarios (FEFA) o (FIRA)',
								'Que cuenta con los siguientes mecanismos de atención “AL ACREDITADO” los cuales se proporcionan de manera gratuita como el teléfono, fax y correo electrónico, señalados en los medios de promoción (tarjetas de presentación) y publicidad (trípticos y volantes).',
								'Que los servicios financieros que presta cumplen con las disposiciones legales vigentes en materia de transparencia, seguridad e información para los usuarios.',
								'Que está de acuerdo en la celebración del presente contrato, por lo que comparece por cuenta de su representada.\n\n'
							]
						},
					],
					[
						{ text: [ 'Bajo protesta de conducirse con verdad Declara ', { text: '"EL ACREDITADO"', bold: true}, ':']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								{ text: ['Es (son) persona(s) física(s), mayor(es) de edad, que cuenta(n) con la debida capacidad y facultades legales necesarias para obligarse en términos del presente contrato; y para recibir cualquier notificación el acreditado señala el siguiente domicilio: ', generales.direccionCliente] },
								'Que es su voluntad aceptar y recibir el crédito materia de este contrato, cuyas especificaciones se señalan en la cláusula primera de este contrato.',
								{ text: ['Que recibió de ', {text: '"LA ACREDITANTE"', bold: true}, ', toda la información relativa al crédito materia de este contrato, incluyendo especificaciones contables, tasas de interés anuales en porcentajes claros, costos de las operaciones y desde luego el CAT costo anual total de toda la operación. Así mismo que se le informó, en su caso, de los límites del seguro de vida, que de ser elegible y aceptado por la aseguradora se contratará para garantizar el cumplimiento del pago del crédito en caso de muerte del acreditado.']},
								'Este Contrato constituye una obligación legal y válida, exigible en su contra de conformidad con sus respectivos términos.',
								{ text: ['Toda la documentación e información que ha entregado a ', { text: '"LA ACREDITANTE"', bold: true},' para el análisis y estudio del otorgamiento del presente Contrato es correcta y verdadera.']},
								'Que se encuentra(n) al corriente en el pago de sus impuestos y obligaciones de carácter fiscal que se generan por los bienes que integran su patrimonio y por sus operaciones sin acreditarlo.',
								'Que a la fecha no existe ninguna acción, juicio o procedimiento alguno de cualquier naturaleza pendiente o en trámite ante cualquier tribunal, dependencia gubernamental o árbitro, que pudiera afectar en forma alguna su condición financiera o sus operaciones.',
								{ text: ['Que para el fomento de sus actividades ha solicitado a ', { text: '"LA ACREDITANTE"', bold: true}, ' el Crédito materia del presente contrato para destinarlo a los fines previstos en el mismo.' ]}
							]
						}
					]
				]
			},
			{
				text:'\n\n'
			},
				'Expuesto lo anterior, los comparecientes celebran el presente contrato de conformidad con las siguientes:',
			{
				text:'\n\n'
			},
			{
				text: 'C L Á U S U L A S:',
				bold: true,
				style: 'header'
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'PRIMERA.-', bold: true },
					'OBJETO Y DESTINO:',
					{ text: '"LA ACREDITANTE"', bold: true },
					' establece en favor de ',
					{ text: '"EL ACREDITADO"', bold: true },
					' un préstamo de habilitación o avío en forma de apertura de crédito SIMPLE hasta por la cantidad de ',
					generales.montoTotal, '.',
					' Este crédito se otorga a ',
					{ text: '"EL ACREDITADO"', bold: true },
					' , por monto y destino que se describen la tabla “A”.',
				]
			},
			{
				text:'\n\n'
			},
			{
				text: 'TABLA "A" BENEFICIARIOS',
				bold: true,
				style: 'header'
			},
			{
				text:'\n\n'
			},
			{
				table: {
					body: crearTablaBeneficiarios(tablaBeneficiarios)
				}
			},
			{
				text:'\n\n'
			},
			{
				text: [
					'Dentro del límite del crédito concedido no quedan comprendidos los intereses, impuestos, comisiones y los gastos que se causen y que en virtud de este contrato deba cubrir ',
					{ text: '"EL ACREDITADO"', bold: true},
					'.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DESTINO. “EL ACREDITADO”', bold: true },
					'se obliga a destinar el importe de las disposiciones de crédito concedido para capital de trabajo, para el concepto de inversión que es objeto del crédito y que fue el señalado en su solicitud de crédito, el cual es ',
					generales.destinoCredito,
					', Obligándose ',
					{ text: '“EL ACREDITADO”', bold: true },
					' a invertir de sus recursos al menos el 20% del costo total de la inversión a realizar.'
				]
			},
			{
				text: [
					'Para efectos de cómputo de los intereses, se tomará como fecha de inicio la fecha en que ',
					{ text: '"EL ACREDITADO"', bold: true },
					' reciba el crédito.'
				]
			},
			{
				text:'\n\n'
			},
			{ text: 'SEGUNDA.- DE LOS CONCEPTOS DE COBRO Y MONTOS.', bold: true },
			{
				type: 'upper-alpha',
				ol: [
					[{
						text: [
							{ text: 'TASA DE INTERÉS:', bold: true },
							' El acreditado se obliga a pagar a la acreditante, sin necesidad de requerimiento previo por concepto de interés simple una ',
							{ text: 'Tasa de interés ordinaria fija anual del ', bold: true },
							{ text: generales.tasaOrdinaria,  bold: true },
							'\n',
							'Método de cálculo.- El monto total de intereses se obtiene por la multiplicación del monto de crédito por el número de días efectivamente transcurridos por la tasa de interés ordinaria pactada expresada en porcentaje sobre 360 días. Nota: los intereses no pueden ser cobrados anticipadamente.\n',
						],
					},
					{
						table: {
							headerRows : 1,
							body: [
									[ { rowSpan: 2, text: '\n                  Interés = \n'} ,{ text: '((Monto de Crédito) (Tasa de Interés Ordinaria) (Días transcurridos en el periodo))', alignment: 'center' }],
									['', { text: '360', alignment: 'center' }]
								],
							},
						layout: 'headerLineOnly',
						alignment: 'center',
					},
					{    text:['\n',
						'Los días transcurridos del periodo consideran desde la fecha de suscripción del presente contrato y las fechas descritas en la Tabla “B” PLAZOS ubicada en la Cláusula Tercera de este contrato. El cálculo de intereses es de tipo global, es decir, se calcula sobre el monto de crédito total y no sobre saldos insolutos.'
					       ,'\n','\n'  ]

					}],

					{
						text: [
							{ text: 'COMISIONES.-', bold: true },
							'Se establece una comisión por apertura de crédito por única vez mientras dure la vigencia de este crédito equivalente al 0.00 % (CERO PUNTO CERO) POR CIENTO ANUAL MÁS I.V.A. del monto de crédito equivalente a $ 0.00 (CERO PESOS 0/100 M.N.). Para obtener el monto de la comisión a pagar debe multiplicarse el crédito otorgado señalado en la cláusula primera de este contrato por el porcentaje de comisión establecido. '
						],
					},
					{
						text: [
							{ text: 'SEGURO DE VIDA.-', bold: true },
							' Con el fin de favorecer la cultura financiera y contar con protección económica en caso de fallecimiento del acreditado, y siempre y cuando ',
							{ text: '"EL ACREDITADO"', bold: true },
							' sea aceptado por la aseguradora para ser asegurado, se contratará un seguro de vida con cobertura suficiente para cubrir el monto del crédito cuyo costo de prima por la vigencia del crédito será de ',
							generales.primaSeguro,
							' para una suma asegurada de ',
							generales.coberturaSeguro,
							', renovable al vencimiento cada ',
							generales.vigenciaLetra,
							' meses durante el año y hasta la liquidación total del crédito, por lo que ',{ text: '"EL ACREDITADO"', bold: true },' autoriza a la ',{ text: '“LA ACREDITANTE”', bold: true },' el cobro de la prima para que por su cuenta y orden pague a la Aseguradora la cuota correspondiente en los meses subsecuentes de vigencia del crédito y/o hasta que se liquide totalmente el saldo insoluto del mismo. Los detalles del aseguramiento se establecerán en la póliza correspondiente. '
						],
					},
					{
						text: [
							{ text: 'CAT.-', bold: true },
							' El Costo Anual Total es de ',
							{ text: generales.CAT, bold: true },
							{ text: ' a Tasa Fija', bold: true },
							'  y para fines informativos y de comparación exclusivamente.'
						],
					},
					{
						text: [
							{ text: 'INTERESES MORATORIOS.', bold: true },
							' En el supuesto de que ',
							{ text: '"EL ACREDITADO"', bold: true },
							' incurriese en mora en el cumplimiento oportuno de sus obligaciones de pago contraídas en el presente contrato,',
							{ text: ' pagará los intereses moratorios que resulten de multiplicar por dos la tasa de interés ordinaria más I.V.A. pactada', bold: true },
							' por el monto del saldo vencido por el número de días que tarde en regularizar su pago, todo esto dividido entre 360 días. Dichos intereses causarán desde la fecha en que incurra en el incumplimiento hasta la regularización de los pagos. Lo anterior será sin perjuicio de que ',
							{ text: '“LA ACREDITANTE”', bold: true },
							' pueda dar por vencido el adeudo anticipadamente en los términos de este contrato.'
						],
					}
				]
			},
			{
				text:'\n\n'
			},
			{ text: 'TERCERA.- PLAZO Y FORMA DE PAGO:', bold: true },
			{
				text: [
					{ text: 'PLAZO.', bold: true },
					' El plazo de duración de este contrato será de ',
					generales.plazo,
					', contados a partir de la fecha de disposición del crédito. Tanto de pago de intereses más I.V.A., como de capital, se realizarán abonos ',
					generales.frecuencia,
					' según se indica en la tabla siguiente:'
				],
			},
			{ text: '\nTABLA "B" PLAZOS', bold: true , style: 'header'},
			{
				text:'\n'
			},
			{
				table: {
					body: crearTabla(amortizaciones)
				}
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'CUARTA.- LUGAR, FORMA DE ENTREGA Y PAGO DEL CREDITO. “El ACREDITADO”', bold: true },
					' pasará personalmente a recoger el importe de su préstamo a las oficinas de ',
					{ text:'"LA ACREDITANTE"', bold: true },
					', el cual recibirá de manos del cajero previa identificación con documento oficial o, en su caso, se transferirá a la cuenta bancaria previamente otorgada y autorizada para tal efecto por el acreditado.'
				]
			},
			{
				text:'\n'
			},
			{
				text: [
					'Todas las cantidades que ',
					{ text: '"EL ACREDITADO"', bold: true},
					' deba pagar por concepto de capital, comisiones, intereses e impuestos, serán pagaderas a través de la cuenta bancaria que para ello determine ',
					{ text:'"LA ACREDITANTE"', bold: true },
					' y solo en aquellos casos en que la sucursal bancaria se encuentre a una distancia considerable de la comunidad, el importe del pago podrá ser entregado al asesor respectivo contra la entrega rigurosa del recibo correspondiente, en los días y horas establecidas sin necesidad de requerimiento o cobro previos.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'QUINTA.-', bold: true },
					' DOCUMENTACIÓN. ',
					{ text:'"LA ACREDITANTE"', bold: true },
					' entregará a ',
					{ text: '"EL ACREDITADO"', bold: true},
					' copia de todos los documentos que el mismo firmó para el otorgamiento de su crédito.-'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'SEXTA.- ESTADOS DE CUENTA Y SALDO. El ACREDITADO Y LA ACREDITANTE', bold: true },
					' acuerdan que el primero consultará personalmente o vía telefónica con su asesor los saldos o estados de cuenta correspondientes, en la Oficina Matriz o en sus diferentes sucursales, en los horarios que la entidad tiene para la atención al público con un horario matutino de las 8:30 a las 14:00 horas y un vespertino de las 15:30 a las 18:00 horas de lunes a viernes. Los estados de cuenta podrá consultarlos ',
					{ text:'"EL ACREDITADO"', bold: true },
					'cada ocho, quince o treinta días según su programa de pagos el cual se establece en la cláusula tercera de este contrato. ',
					{ text:'"EL ACREDITADO"', bold: true },
					' dispondrá de tres días hábiles para objetar o solicitar cualquier aclaración de su saldo.',
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					'Una vez que ',
					{ text:'“EL ACREDITADO”', bold: true },
					' liquide totalmente el saldo insoluto del crédito, ',
					{ text:'“LA ACREDITANTE”', bold: true },
					' está obligada a reportar a las Sociedades de Información Crediticias “SICS” a más tardar el día 10 del mes siguiente respecto del mes en el cual se liquidó el crédito, que la cuenta de ',
					{ text:'“EL ACREDITADO”', bold: true },
					' está cerrada sin adeudo alguno. ',
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'En este caso, o para cualquier solicitud, consulta, aclaración, inconformidad y/o queja, relacionada con la operación o servicio contratado “EL ACREDITADO” podrá llamar o acudir a la Unidad Especializada de Atención a Usuarios con domicilio en ', bold: true },
					'Juárez Norte No. 6, Colonia. Centro, C.P. 45640, Tlajomulco de Zúñiga, Jalisco, Tel: (33) 379 82000, 379 80766, Fax. 379 80237.',
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'SÉPTIMA.- PAGOS ANTICIPADOS.- “LA ACREDITANTE”', bold: true },
					' está obligada a aceptar pagos anticipados de los créditos menores al equivalente a 900,000 UDIS, siempre que los Usuarios lo soliciten y  estén al corriente en los pagos exigibles de conformidad con el contrato respectivo. ',
					{ text: '“EL ACREDITADO”', bold: true },
					' podrá hacer pagos anticipados a cuenta de capital e intereses más I.V.A., o bien podrá liquidarlo totalmente antes de su vencimiento siempre y cuando haya transcurrido el 87% del periodo de vigencia del crédito contratado.  Si el ',
					{ text: '“EL ACREDITADO”', bold: true },
					' decide liquidarlo antes de transcurrido este periodo de vigencia mencionado,',
					{ text: '“EL ACREDITADO”', bold: true },
					' está de acuerdo en cubrir a ',
					{ text: '“LA ACREDITANTE”', bold: true },
					' el saldo de capital no pagado del crédito contratado más los intereses acumulados no pagados más el impuesto respectivo con fecha de cálculo de intereses a un plazo mínimo del 87% de la vigencia del crédito contratado. En virtud de que el cálculo de interés es de tipo global, es decir, se calcula sobre el monto de crédito original, los pagos anticipados no reducirán los intereses calculados del periodo a pagar, dado que el cálculo no es sobre saldos insolutos. ',
					{ text: '“LA ACREDITANTE”', bold: true },
					' aplicará los pagos anticipados al saldo del crédito y deberá entregarle un comprobante de dicho pago, en físico, o en electrónico. En caso de que el ',
					{ text: '“EL ACREDITADO”', bold: true },
					' tenga un saldo a favor después de liquidar totalmente el crédito en cuestión, ',
					{ text: '“LA ACREDITANTE”', bold: true },
					' le informará a ',{ text: '“EL ACREDITADO”', bold: true },' por medio escrito, electrónico o telefónico que tiene un saldo a favor y por lo tanto deberá proporcionar a ',
					{ text: '“LA ACREDITANTE”', bold: true },
					' los datos de cuenta bancaria para la devolución vía transferencia electrónica bancaria, o bien vía cheque si así lo solicita.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'OCTAVA.- CAUSAS DE RESCISIÓN.', bold: true },
					' Serán causales de rescisión del presente contrato:',
				]
			},
			{
				text:'\n\n'
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Si ', { text: '"EL ACREDITADO"', bold: true }, ' deja de pagar oportunamente las amortizaciones correspondientes tanto de capital como de intereses más I.V.A. o los gastos que se causen en virtud de este contrato.'] },
					'Si vende, enajena, arrienda, cambia de lugar o constituye algún gravamen sobre los bienes dados en garantía.',
					'Si los bienes materia de la garantía fueren objeto de embargo total o parcial, ya sea de orden civil, mercantil, fiscal, laboral, administrativo o de cualquier otra índole o si el valor de dichas garantías se redujera en más de un 20% veinte por ciento.',
					'Si abandona la administración de la empresa o no la atiende con el debido cuidado y eficiencia.',
					'Si se presentan conflictos o situaciones de cualquier naturaleza que afecten el buen funcionamiento de su empresa o menoscaben las garantías establecidas.',
					{ text: ['Si no entrega a ', { text: '"LA ACREDITANTE"', bold: true}, ' la información contable y financiera, según se establezca en el contrato respectivo.' ]},
					{ text: ['Si no da las facilidades necesarias al interventor que designe ', { text: '"LA ACREDITANTE"', bold: true}, ' para el cumplimiento de su cometido' ]},
					'Si no cumple con cualquiera de las obligaciones contenidas en el presente contrato.',
					'Si desvía los recursos del crédito hacia otros fines distintos de los pactados',
					'Por cualquier otra causa estipulada en el presente contrato o derivada de la ley.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'NOVENA.- FORMAS DE NOTIFICACIÓN. “LA ACREDITANTE”', bold: true },
					' notificará por escrito en el domicilio que ',
					{ text: '"EL ACREDITADO"', bold: true },
					' haya señalado para tal efecto, sobre cualquier modificación del presente contrato de adhesión, respecto de la operación o servicio que ',
					{ text: '"EL ACREDITADO"', bold: true },
					' tenga contratado, se le hará saber con cuarenta días naturales de anticipación antes de su entrada en vigor, las nuevas bases de operación. En el evento de que ',
					{ text: '"EL ACREDITADO"', bold: true },
					' no esté de acuerdo con las modificaciones propuestas, podrá solicitar la terminación del Contrato de Adhesión hasta 60 días naturales después de la entrada en vigor de dichas modificaciones, sin responsabilidad ni comisión alguna a su cargo, debiendo cubrir, en su caso, los adeudos que ya se hubieren generado a la fecha en que solicite dar por terminada la operación o el servicio de que se trate. Una vez transcurrido el plazo señalado sin que ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' haya recibido comunicación alguna por parte de ',
					{ text: '"EL ACREDITADO"', bold: true },
					', se tendrán por aceptadas las modificaciones al Contrato de Adhesión'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text:'DECIMA.- DEL PROCEDIMIENTO DE CANCELACIÓN.', bold: true },
					' En caso de que ',
					{ text: '"EL ACREDITADO"', bold: true },
					' quiera cancelar sus operaciones o servicios con la entidad, deberá acudir personalmente con su asesor financiero a entregarle por escrito su solicitud de cancelación, para que este a su vez realice los trámites correspondientes para tal efecto. Para que esto proceda el Acreditado demostrará que no tiene saldos pendientes con la entidad sobre ninguno de los rubros que se señalan en este contrato.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text:'DECIMA PRIMERA.- GARANTÍAS SOLIDARIAS.-', bold: true },
					'En cumplimiento de todas y cada una de las obligaciones derivadas del presente contrato, se constituye a favor de ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' las siguientes:'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ stack: [
							{
								text:[
									'Garantía PRENDARIA O HIPOTECARIA. A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los “Pagarés”, y especialmente para garantizar el pago del Crédito, su suma principal, interés ordinario e interés moratorio, en su caso, comisiones, costos, gastos e impuestos y todas y cada una de las demás cantidades pagaderas por ',
									{ text: '"EL ACREDITADO"', bold: true },
									' a ',
									{ text: '"LA ACREDITANTE"', bold: true },
									', ',
									{ text: '“EL GARANTE (S) PRENDARIO (S) O HIPOTECARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO”', bold: true },
									'con el conocimiento (en su caso) de su (s) cónyuge (s), el (los) señor (es) ',
									crearNomGaranYAval(listaGarantes, listaAvales, generales),
									' constituye (n) en favor de ',
									{ text: '"LA ACREDITANTE"', bold: true },
									'  un gravamen/hipoteca en primer lugar y grado sobre el (los) bien (es) mueble (s), /inmueble (s) descritos a continuación:\n'

								]


							},
							'\n',
							creaTablaGarantiasHipot(garantias, firmas),
							'\n'


						],



					},

					{ text: [
						'Garantía Liquida Solidaria: ',
						{ text: '"EL ACREDITADO"', bold: true },
						' aporta en garantía liquida un monto de dinero equivalente a ',
						generales.montoGarLiquida,
						' el cual corresponde al ',
						generales.porcGarLiquida,
						' del importe del crédito. El depósito deberá realizarse previo a la ministración del crédito en la cuenta de banco que ',
						{ text: '"LA ACREDITANTE"', bold: true },
						' defina. ',
						{ text: '"EL ACREDITADO"', bold: true },
						' está de acuerdo en que de presentarse algún atraso en cualesquiera de sus amortizaciones, esta garantía se aplicará totalmente como abono al crédito hasta donde alcance su importe, por lo que faculta a ',
						{ text: '"LA ACREDITANTE"', bold: true },
						' para su aplicación sin necesidad de previo aviso a ',
						{ text: '"EL ACREDITADO".', bold: true },
					]
					},
				]
			},
			{
				text:'\n\n'
			},
			{ text: [
				'Las garantías establecidas en la presente cláusula, no podrán restringirse ni cancelarse mientras que resulte algún saldo a favor de ',
				{ text: '"LA ACREDITANTE"', bold: true },
				' y a cargo de ',
				{ text: '"EL ACREDITADO"', bold: true },
				', ya sea por el crédito concedido o demás accesorios pactados, bien porque no haya llegado a su vencimiento, ya porque ',
				{ text: '"LA ACREDITANTE"', bold: true },
				' hubiera otorgado espera y aún porque el adeudo se hubiere documentado en nuevos títulos de crédito.'
			]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DECIMA SEGUNDA.- DEPOSITARIO.-', bold: true },
					' Designan las partes como Depositario de los bienes pignorados al propio ',
					{ text: '“EL(LOS) (LAS) AVAL(ES) U OBLIGADO(AS) SOLIDARIO(AS)”', bold: true },
					' por conducto de ',
					{ text: '"EL ACREDITADO"', bold: true },
					', constituyéndose el depósito en los domicilios señalados en sus generales quienes en este acto acepta (n) el cargo de Depositario y protestan su fiel y legal desempeño.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DÉCIMA TERCERA.- CLAVE DE REGISTRO DEL CONTRATO:', bold: true },
					' El presente contrato se encuentra registrado ante la Comisión Nacional para la Protección y Defensa de los Usuarios de Servicios Financieros (CONDUSEF) con el número de registro ',
					generales.reca,
					', misma que cuenta con el siguiente número telefónico de atención a usuarios (0155-53400999 o LADA sin costo 01800-9998080), dirección en Internet (www.condusef.gob.mx) y correo electrónico (opinion@condusef.gob.mx).'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DÉCIMA CUARTA.- ORDENAMIENTO ECOLÓGICO. “EL ACREDITADO”', bold: true },
					' se obliga a “considerar y cumplir con el ordenamiento ecológico y con la preservación y mejoramiento del medio ambiente, la protección de las áreas naturales, la previsión y el control de la contaminación del aire, agua y suelo, así como las demás disposiciones previstas en la Ley General de Equilibrio Ecológico y Protección del Medio Ambiente, vigente a la fecha de la firma del presente contrato, debiendo manejar racionalmente los recursos naturales, acatar las medidas y acciones dictadas por las autoridades competentes, y cumplir con las orientaciones y recomendaciones técnicas de FIRA y/o la persona que cualquiera de ellos designe”.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DÉCIMA QUINTA.- COMPETENCIA, INTERPRETACIÓN Y VIGILANCIA.', bold: true },
					'Todas las controversias que surjan con motivo del presente contrato de adhesión deberán ser resueltas con base en lo señalado en la Ley de Transparencia y Ordenamiento de los Servicios Financieros, Ley de protección y defensa al usuario de servicios financieros y demás relativas y supletorias que la misma ley señala, siendo la CONDUSEF, la competente para resolver su aplicación e interpretación. Así mismo las partes se someten expresamente a la jurisdicción o competencia de los Tribunales de su domicilio en lo que fuera aplicable.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: [
					{ text: 'DECIMA SEXTA.- JURISDICCIÓN.-', bold: true },
					' Para la interpretación y cumplimiento del presente contrato, así como para el caso de cualquier controversia, litigio o reclamación de cualquier tipo, en contra de cualquiera de las partes de este contrato, todos aceptan someterse expresamente a la jurisdicción y competencia de los tribunales competentes del Trigésimo primer partido judicial con sede en la cabecera municipal de Tlajomulco de Zúñiga, o en Guadalajara, ambas, estado de Jalisco, renunciando clara y terminantemente al fuero que la ley concede, que por razón de sus domicilios presentes o futuros pudieran corresponderles. Todas las controversias que surjan con motivo del presente contrato de adhesión deberán ser resueltas con base en lo señalado en la Ley de Transparencia y Ordenamiento de los Servicios Financieros. Ley de protección y defensa al usuario de servicios financieros y demás relativas y supletorias que la misma ley señala, siendo la comisión nacional, la competente para resolver su aplicación e interpretación.'
				]
			},
			{
				text:'\n\n'
			},
			{
				text: 'G E N E R A L E S',
				bold: true,
				style: 'header'
			},
			{
				text: [
					'Los que suscriben el presente contrato manifiesta ser: ',
					generales.nomRepresentanteLeg,
					' declara por sus generales ser mexicano por nacimiento, nació el ',
					generales.fechaNacRepLegal,
					' con domicilio en ',
					generales.direcRepLegal,
					'. Quien se identifica con credencial de elector folio ',
					generales.identRepLegal,
					'\n'
				]
			},
			{
				table: {
					body: crearTablaIntegrantes(tablaIntegrantes, integrantes)
				}
			},
			{ text: '\n\n' },
			{
				text: [
					'Las partes manifiestan que en la celebración del presente contrato no ha existido ningún vicio del consentimiento, que pudiera ser causa de nulidad o rescisión de este contrato y si lo hubiere, desde este momento renuncian a la acción de nulidad que les pudiere corresponder, en testimonio de lo anterior, y conformes ',
					{ text: '"LAS PARTES"', bold: true },
					' de que la carátula de este instrumento y las cláusulas anteriores son complementarias e integrantes de un mismo instrumento se firma por ',
					{ text: '"LAS PARTES"', bold: true },
					', por triplicado en Tlajomulco de Zúñiga, Jalisco a los ',
				        {text: generales.fechaIniCredito, bold: true },
					'.'

				]
			},
			{ text: '\n\n'},
			{
				stack: [
					'POR LA ACREDITANTE',
					'\n',
					'\n',
					'___________________________________',
					generales.nomApoderadoLegal,
					'APODERADO LEGAL'
				],
				bold: true,
				style: 'header',
			},
			{ text: '\n\n'},
			{
				stack: [
					'POR "EL ACREDITADO',
					'\n',
					'\n',
					'___________________________________',
					generales.nombreCliente,
					{text:generales.direccionCliente,bold:false}
				],
				bold: true,
				alignment: 'center'
			},
			{

				stack: [
							'\n\n',
							{ text:' POR “EL GARANTE(S) PRENDARIO(S) O HIPOTECARIO(S)”', bold: true },
				        	firmantesGarantes(listaGarantes)
				        ],
				alignment: 'center',
				pageBreak: 'before'


			},
			{

				stack: [
							'\n\n\n',
							{ text:' “LOS AVALES”', bold: true },

				        	firmantesAvales(listaAvales)
				        ],
				alignment: 'center'


			},
			{

				stack: [
							'\n\n\n',
							{ text:' “LOS TESTIGOS”', bold: true },

				        	firmantesAvales(listaUsuarios)
				        ],
				alignment: 'center'


			},

		],
		styles: {
			header: {
				alignment: 'center'
			}
		},
		defaultStyle: {
			font: 'arial',
			fontSize: 8,
			alignment: 'justify'
		}
	};

	pdfMake.createPdf(documento).open();
}

function firmantesGarantes(integrantes) {
	var firmas = [];
	if(integrantes != null){
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


function firmantesAvales(integrantes) {
	var firmas = [];
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
	return firmas;
}


function crearTabla(amortizaciones) {
	var tablaAmortizaciones = [
		[{ text: 'AMORTIZACIÓN', bold: true, style: 'header'}, { text: 'FECHA DE VENCIMIENTO', bold: true, style: 'header'}, { text: 'MONTO DE PAGO', bold: true, style: 'header'}]
	];
	if(amortizaciones != null){
		amortizaciones.forEach(function(amortizacion) {
			tablaAmortizaciones.push([{ text: amortizacion.amortizacionID, alignment: 'center'},
									amortizacion.fechaExigible,
									amortizacion.montoCuota]);
		});
	}


	return tablaAmortizaciones;
};

var tablaBeneficiarios = [
	[ { text: 'No.', bold: true, alignment: 'center' }, { text: 'NOMBRE', bold: true, alignment: 'center' }, { text: 'MONTO', bold: true, alignment: 'center' }, { text: 'DESTINO', bold: true, alignment: 'center' }],
];

function crearTablaBeneficiarios(tablaBeneficiarios) {
	tablaBeneficiarios = [
		[ { text: 'No.', bold: true }, { text: 'NOMBRE', bold: true }, { text: 'MONTO', bold: true }, { text: 'DESTINO', bold: true }],
		[ { text: '1', bold: true }, { text: generales.nombreCliente}, { text: generales.montoTotal}, { text: generales.destinoCredito}],
		[ { text: 'TOTAL',alignment: 'center', bold: true,  colSpan: 2},{}, { text: generales.montoTotal, bold: true }, { text: generales.montoLetra, bold: true }]
	];

	return tablaBeneficiarios;
};

var tablaIntegrantes = [
		[
			{ text: 'NOMBRE', bold: true },
			{ text: 'R.F.C.', bold: true },
			{ text: 'DOMICILIO', bold: true },
			{ text: 'IDENTIFICACIÓN FOLIO IFE / INE', bold: true }
		]
];

function crearTablaIntegrantes(tablaIntegrantes, integrantes) {
	tablaIntegrantes = [
		[
			{ text: 'NOMBRE', bold: true },
			{ text: 'R.F.C.', bold: true },
			{ text: 'DOMICILIO', bold: true },
			{ text: 'IDENTIFICACIÓN FOLIO IFE / INE', bold: true }
		]
	];

	integrantes.forEach(function(integrante) {
		tablaIntegrantes.push([
			integrante.nombre,
			integrante.rfc,
			integrante.domicilio,
			integrante.identificacion
		]);
	});
	return tablaIntegrantes;
};

Array.prototype.unique=function(a){
  return function(){return this.filter(a)}}(function(a,b,c){return c.indexOf(a,b+1)<0
});

function crearNomGaranYAval(Garantes, Avales, General) {
		var NomGaranYAval = '';
		var totalGarantes = 0;
		var totalAvales = 0;
		var contador = 0;
		var ArrayGarantes = [];
		var ArrayAvales = [];
		var Arraycliente=[];
		var ArrayFinal = [];

		if(Garantes != null){
			totalGarantes = Garantes.length;
			for (var i = 0; i < totalGarantes; i++) {
				ArrayGarantes[i] = Garantes[i].nombre;
			}
		}
		if(Avales != null){
			totalAvales = Avales.length;
			for (var i = 0; i < totalAvales; i++) {
				ArrayAvales[i] = Avales[i].nombre;
			}

		}

		Arraycliente[0] = '';

		if(Garantes != null && Avales == null ){
			Array.prototype.push.apply(Arraycliente, ArrayGarantes);
			ArrayFinal = Arraycliente.unique();
		}else if(Avales != null && Garantes == null ){
			Array.prototype.push.apply(Arraycliente, ArrayAvales);
			ArrayFinal = Arraycliente.unique();
		}else if(Garantes != null &&  Avales != null){
			Array.prototype.push.apply(ArrayGarantes, ArrayAvales);
			ArrayFinal = ArrayGarantes.unique();
		}else{
			ArrayFinal = Arraycliente;
		}

		var totalInt = ArrayFinal.length;
		var numreg = totalInt - 1;
		if(totalInt > 1) {
			for (var i = 0; i < totalInt; i++) {
				if (contador < totalInt){
						if(contador == numreg) {
							NomGaranYAval = NomGaranYAval + ' Y ' + ArrayFinal[i] ;
						}else{
							if(contador == numreg -1) {
								NomGaranYAval = NomGaranYAval + ' ' + ArrayFinal[i] + '';
							}else{
								NomGaranYAval = NomGaranYAval + ' ' + ArrayFinal[i]+ ',';
							}
					}
				}
				contador ++;
			}
		}else{
			NomGaranYAval = ArrayFinal[0];
		}


	return NomGaranYAval;
};

function creaTablaGarantiasHipot(integrantes, firmas) {

    var firmas = [];

	if(integrantes != null){
		for (i=0, len = integrantes.length; i < len; i++) {

			firmas.push({
				columns: [
					{
						ul:[ integrantes[i].tipoGarantia + ': ' + integrantes[i].observaciones]

					}
				]
			});
		}

	}


	return firmas;
}

function creaTablaGarantias(integrantes, firmas) {

    var firmas = [];

		firmas.push({
			columns: [
				{
					ul:[ 'Garantía liquida por el ' + 	generales.porcGarLiquida + ' del monto del crédito equivalente a ' + generales.montoGarLiquida]

				}
			]
		});

	if(integrantes != null){
		for (i=0, len = integrantes.length; i < len; i++) {

			firmas.push({
				columns: [
					{
						ul:[ integrantes[i].tipoGarantia + ': ' + integrantes[i].observaciones]

					}
				]
			});
		}

	}


	return firmas;
}

function aliasCliente(parAlias){
	var texto = '';

	if(parAlias != ''){
	texto = ' TAMBIEN CONOCIDA (O) INDISTINTAMENTE CON EL (LOS) NOMBRE (S) '+parAlias;
	}

	return texto;
	}

function dividirString(cadena){
	var separador = '-';
	var arrayDeCadenas = cadena.split(separador);
	return arrayDeCadenas;
}

function formatoString(cadena){
	var texto = '';
	var totalStr = cadena.length - 1;
		texto = cadena.substr(0,totalStr);
	return texto;
}

function adecuarCadena(cadena){
	var separador = ',';
	var arrayDeCadenas = cadena.split(separador);
	var numReg = arrayDeCadenas.length;
	var texto = '';

	for(i=0; i < numReg; i++){
		if(i < numReg-2){
			texto = texto + arrayDeCadenas[i] + ',';
		}else{
			texto = texto + arrayDeCadenas[i] + '';
		}
	}
	return texto;
}

var formulaInteres = 'data:image/png;base64,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';

var logoConsol = 'data:image/jpeg;base64,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8FHgTihT5FDotWQQQKterRuSjxJxR3DxQQLWlft4q8ndjN8FJtG6mUIY/wB2KvMmaUPQ9tpBG3wwv3mrD0ND1QQkrdo9DZWtaBjm8BC9v60qxXiTDrajNkhHsXqy1Hpuv/uQxpelWK/BybTlHGcHq2Wjo2SktCHft7VYr0gSvavYr0KZ4mMLZjVSPoNPlHC83/A8l96sV6JtpQle/AqjG270aWYnXI0vwVYr1Y0o+MJ3s7Ud52oTveWi2I+z4EeyJ8VWK/ImVDdb89WK/wAyrFf5lWGcP5iNzz0nSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpQkVf4IOop/M2222222222222zDh/2Yf/EACsQAQACAAQEBgMBAQEBAAAAAAEAESExQWEQUXGBIJGhscHwMEDR4fFQYP/aAAgBAAABPxCYcZvSKW1tly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXEbVSp83FYukuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cueq4rH0ly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1PFYuhLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLnquL8oly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1fFeUS5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly/AS8gly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLl+AH5RLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLmPiH5BLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXL8GLyiXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuX4EflEuXLly5cuXLly5cuXLly5cuXLgdg7BOZvJmeuDUMy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';
