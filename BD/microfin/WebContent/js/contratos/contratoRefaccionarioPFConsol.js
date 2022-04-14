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

var catTipoConsultaGarFIRA = {
	'refaccionarioFEGA' : 1,
	'refaccionarioFONAGA' : 2,
	'avioFEGA' : 3,
	'avioFONAGA' : 4
};
var catSubClasificaCred = {
	'refaccionario' : 126,
	'avio' : 125
};

var catGarantiaFira = {
	'FEGA' : 1,
	'FONAGA' : 2
};

var catTiposGarantia = {
	'prendaria' : '2',
	'hipotecaria' : '1'
};

var documento;

var contratoIndividual = 1;
var contratoAgro = 1;

var listaIntegrantes = 15;
var generales = [];
var integrantes = [];
var amortizaciones = [];
var garantias = [];
var listaGarantes = [];
var listaAvales = [];
var listaUsuarios = [];
var firmas = [];

var generalesAgro = [];
var garantiasFira = [];
var ministraciones = [];
var garantiasGarantes = [];
var consejoAdmon = [];

var paramUEAU = [];

function generarContratoRefaccionarioPF(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
						RFCInst, direccionInst, telefonoInst, 
						calcInteres, fechaEmision) {
							
	var credito = {
		'creditoID': creditoID
	};

	contratoCreditoAgroServicio.consulta(contratoAgro,  credito,{ async: false, callback:function(contrato){
		generales = contrato[0];
		amortizaciones = contrato[1];
		garantias = contrato[2];
		generalAvales = contrato [3];
		generalGarantes = contrato [4];
		integrantes = contrato[5];
		listaGarantes = contrato[6];
		listaAvales = contrato[7];
		listaUsuarios = contrato[8];
		generalesAgro = contrato[9];
		garantiasFira = contrato[10];
		ministraciones = contrato[11];
		garantiasGarantes = contrato[12];
		consejoAdmon = contrato[13];
	}});

	edoCtaParamsServicio.consulta(1,{ async: false, callback:function (EdoCta){
		if(EdoCta!=null){						
			paramUEAU = EdoCta
		}
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
			{ text: ['CONTRATO DE ADHESIÓN CRÉDITO ',generalesAgro.nombreProd],
				alignment: 'left',
				margin: [25, 25, -35, 0]
			},
			{ stack: [
			'No. de Crédito ' + generales.creditoID,
			'RECA: ' + generales.reca
				],
				alignment: 'right',
				margin: [35, 25, 25, 0]
			},
			]
		},
		content: [

			// ********************** Titulo *********************
			{ columns: [
					{
					image: logoConsol,
					width: 40,
					height: 60
					},
					{ text: [
								'\n',
								'CONSOL NEGOCIOS, S.A. DE C.V. SOFOM ENR\n',
								{ text: 'SÍNTESIS DEL CONTRATO DE ADHESIÓN EN CUADRO INFORMATIVO\n', bold: true },
								'El siguiente cuadro informativo forma parte integral del contrato de adhesión.'
					],
					style: 'header'
					}
				],
				margin: [20, 0, 20, 0]
			},

			// ************** Carátula del Contrato **************
			{ table: {
				widths: [175, '*'],
				body: [
					[
						{ text: 'CAT a la fecha de contratación, a tasa fija y/o tasa variable, para fines informativos y de comparación exclusivamente:', bold: true },
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
						{ text: 'Tasa de Interés Ordinaria por DOS más I.V.A.', bold: true },
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
							{text:' Cobertura:\n', bold: true },
							{text:' Prima cubierta por el cliente:\n', bold: true },
							{text:' Vigencia:', bold: true },
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
						{ text:'Garantía FEGA:', bold: true },
						{ text:[garantiaFira(catTipoConsultaGarFIRA.refaccionarioFEGA, garantiasFira),' más I.V.A. por el monto del crédito.']},
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

			// **************** Tabla de garantías ***************
			{
				table: {
					widths: ['*'],
					body: [
						[
							{ stack: [
								{ text: 'GARANTÍAS: Para garantizar el pago de este crédito, "EL GARANTE PRENDARIO(S),  GARANTE(S)  HIPOTECARIO(S)  O  USUFRUCTUARIO(S)" deja en garantía el bien que se describe a continuación:', bold: true}
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

			// ************** Tabla de amortización **************
			{ text: '\n\n'},
			{ text: 'TABLA DE AMORTIZACIÓN\n',
				bold: true,
				style: 'header'
			},
			{
				table: {
					body: crearTabla(amortizaciones)
				}
			},
			
			// **************** Firma acreditante ****************
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
			
			// **************** Firma Acreditado *****************
			{ text: '\n\n'},
			{
				stack: [
					'POR "EL ACREDITADO"',
					'\n',
					'\n',
					'___________________________________',			
					generales.nombreCliente+aliasCliente(generales.aliasCliente),
					generales.direccionCliente
				],
				bold: true,
				style: 'header',
				alignment: 'center',
				pageBreak: 'after'
			},

			// *************** Generales contrato ****************
			{
				text: [
					'CONTRATO DE APERTURA DE CRÉDITO AGROPECUARIO ',
					{ text: 'REFACCIONARIO, ', bold: true },
					'CON GARANTÍA PRENDARÍA, USUFRUCTUARIA, HIPOTECARIA Y/O GARANTÍA LIQUIDA QUE CELEBRAN POR UNA PARTE LA EMPRESA DENOMINADA "',
					{ text: razonSocialInst, bold: true },
					'" COMO ACREDITANTE, A QUIEN EN LO SUCESIVO Y PARA EFECTOS DEL PRESENTE CONTRATO SE DENOMINARA ',
					{ text: ' "LA ACREDITANTE"', bold: true },
					', REPRESENTADO EN ESTE ACTO POR EL C. ',
					{ text: generales.nomApoderadoLegal, bold: true },
					', EN SU CARÁCTER DE ',
					{text: generales.cargoApoLegal},
					' Y POR LA OTRA PARTE POR SU PROPIO DERECHO EL (LOS) SEÑOR(ES): ',
					{ text: generales.nombreCliente, bold: true },' ',
					aliasCliente(generales.aliasCliente).toUpperCase().substring(1),
					', COMO ACREDITADO(S) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO ',
					{ text: '"EL ACREDITADO"', bold: true },
					', ASÍ MISMO COMPARECE(N) EL(LOS) SEÑOR(ES), LA PERSONA MORAL:',
					generalGarantes.cadenaGarantes,
					' COMO GARANTE(S) PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) Y/O GARANTE(S) USUFRUCTUARIO(S) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO ',
					{ text: ' "EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)"', bold: true },
					', ASÍ MISMO COMPARECE (N) EL (LOS) SEÑOR (ES), LA PERSONA MORAL: ',
					generalAvales.cadenaAvales,
					' COMO EL (LOS) AVAL (ES) U OBLIGADO SOLIDARIO A QUIEN (ES) EN LO SUCESIVO SE LE (S) DENOMINARÁ CONJUNTA E INDISTINTAMENTE COMO ',
					{text: '"EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true},
					', DE CONFORMIDAD CON LAS SIGUIENTES DECLARACIONES Y CLÁUSULAS.'
				],
			},

			// *********** Declaraciones del contrato ************
			{ text: '\n\n' },
			{ text: 'D E C L A R A C I O N E S', style: 'header', bold: true},
			{ text: '\n\n' },
			{
				type: 'upper-roman',
				ol: [
					
					[
						{ text: [' Bajo protesta de decir verdad declara "CONSOL NEGOCIOS SOCIEDAD ANÓNIMA DE CAPITAL VARIABLE SOCIEDAD FINANCIERA DE OBJETO MÚLTIPLE ENTIDAD NO REGULADA" (SOFOM ENR) por conducto de su representante legal:'] },
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								'Que es una Sociedad Anónima de Capital Variable legalmente constituida conforme a las leyes de la República Mexicana, según consta en Escritura Pública número 13,424 de fecha 05 de agosto de 2004 pasada ante la fe del Notario Público número 3 tres de la ciudad de Tlajomulco de Zúñiga, Jalisco, Licenciado Edmundo Márquez Hernández. Inscrita en el Registro Público de la Propiedad y de Comercio del Estado de Jalisco con el folio mercantil Electrónico No. 23674*1, el día 17 de agosto de 2-e04.',

								'Que con fecha 05 (Cinco) del mes de Marzo del 2007 se cambió la denominación social de "FIRAGRO SA de CV" a "CONSOL NEGOCIOS SA de CV SOFOM ENR", según consta en la Escritura Pública número 16,356 (Dieciséis Mil Trescientos Cincuenta y Seis) otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández, en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco e inscrita en el Registro Público de la Propiedad y de Comercio del estado de Jalisco con fecha 29 de marzo del 2007 con el folio mercantil Electrónico No. 23674*1',

								{ text: ['Las facultades con las que actúa no le han sido revocadas ni restringidas, por lo que comparece en pleno ejercicio de facultades delegadas, según consta en la Escritura Pública número 16,473 (Dieciséis Mil Cuatrocientos Setenta y tres) que contiene la aclaración de la sociedad denominada CONSOL NEGOCIOS S.A. DE C.V. SOFOM ENR, de fecha 02 (Dos) de mayo del 2007 otorgada bajo la fe del notario público número 3 (tres) Lic. Edmundo Márquez Hernández, en legal ejercicio en la ciudad de Tlajomulco de Zúñiga, Jalisco, e inscrita en el Registro Público de la Propiedad y de Comercio del Estado de Jalisco con fecha 25 de junio del 2007.']},
																
								{ text: ['La personalidad con la que se actúa se acredita mediante la Escritura Pública número ' +  generales.numEscPub + ' de fecha ' + generales.fechaEscPub + ' otorgada ante la Fe del Notario Público Número ' + generales.numNotariaPub + ' de la Ciudad de '+ generales.nomMunicipioEscPub + ', ' + generales.nomEstadoEscPub + ', Lic. '+ generales.nombreNotario +' inscrita en el Registro Público de la Propiedad y de Comercio con el Folio Mercantil Electrónico No. ' + generales.folioMercantil + ' en el cual se otorga al  ', { text: 'C. ' + generales.nomApoderadoLegal, bold: true },' poder Judicial para Pleitos y Cobranzas y para Suscripción de Títulos y Operaciones de Crédito en los términos del Artículo 9° noveno de la Ley General de Títulos y Operaciones de Crédito.'] },

								'Que para su constitución y operación como SOCIEDAD FINANCIERA DE OBJETO MÚLTIPLE ENTIDAD NO REGULADA, no requieren de autorización de la Secretaría de Hacienda y Crédito Público.',
								
								'Que tiene su domicilio en calle Juárez Norte número 06 Colonia Centro, C.P. 45640, en Tlajomulco de Zúñiga, Jalisco.',

								'Que la sociedad anónima que representa tiene por objeto social entre otros, el arrendamiento y factoraje financiero, así como el otorgar financiamiento a las personas físicas o morales cuya actividad sea la producción, acopio y distribución de bienes y servicios de o para los sectores agropecuario, silvícola y pesquero; así como de la agroindustria y de otras actividades conexas o afines o que se desarrollen en el medio rural. Realizar actividades y operaciones de crédito y servicios, sin que dentro de estas actividades y de sus estados financieros se incluya la intermediación de recursos provenientes de captación directa del público o créditos de personas físicas o morales no reguladas por las autoridades financieras. Para tal efecto tiene un contrato de apertura de línea de crédito con el banco de México en su carácter de fiduciario del fideicomiso denominado Fondo Especial para Financiamientos Agropecuarios (FEFA) o (FIRA). ',

								'Para la realización de las operaciones señaladas, no está sujeta a la supervisión y vigilancia de la Comisión Nacional Bancaria y de Valores.',
								
								'Que tiene autorización del BANCO DE MÉXICO COMO FIDUCIARIO DEL FIDEICOMISO DENOMINADO FONDO ESPECIAL PARA FINANCIAMIENTOS AGROPECUARIOS, para operar como SOFOM ENR.',

								'Que está de acuerdo en la celebración del presente contrato, por lo que comparece por cuenta de su representada.\n\n\n'
							]
						},
					],
					[
						{ text: [ 'Bajo protesta de conducirse con verdad Declara ', { text: '"EL ACREDITADO"', bold: true}, ':']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								{ text: ['Es (son) persona(s) física(s), mayor(es) de edad, que cuenta(n) con la debida capacidad y facultades legales necesarias para obligarse en términos del presente contrato.'] },

								'Este Contrato constituye una obligación legal y válida, exigible en su contra de conformidad con sus respectivos términos.',

								'Toda la documentación e información que ha entregado a "La Acreditante" para el análisis y estudio del otorgamiento del presente Contrato es correcta y verdadera.',

								'Es su voluntad celebrar el presente Contrato y obligarse en los términos del mismo.',

								'Que se encuentra(n) al corriente en el pago de sus impuestos y obligaciones de carácter fiscal que se generan por los bienes que integran su patrimonio y por sus operaciones sin acreditarlo.',

								'Que a la fecha no existe ninguna acción, juicio o procedimiento alguno de cualquier naturaleza pendiente o en trámite ante cualquier tribunal, dependencia gubernamental o árbitro, que pudiera afectar en forma alguna su condición financiera o sus operaciones.',

								{text: ['Que para el fomento de sus actividades ha solicitado a ',{ text: '"LA ACREDITANTE"', bold: true},'el Crédito materia del presente contrato para destinarlo a los fines previstos en el mismo.\n\n\n']}
							]
						}
					],
					[
						{ text: [ 'Declara(n)  ', { text: '"EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)" Y "EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true}, ' que:']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								'Es (son) persona(s) física(s), mayor(es) de edad, persona moral legalmente constituida, que cuenta(n) con la debida capacidad y facultades legales necesarias para obligarse en términos del presente contrato.',

								{text: ['Que es su interés constituirse en el presente instrumento en cuanto ',{ text: '"EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)" Y "EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true},' de la "PARTE ACREDITADA" adquiriendo los derechos y obligaciones que del mismo se deriva.\n\n\n']}
							]
						}
					],
					[
						{ text: [ { text: '"DECLARACIONES COMUNES QUE DERIVAN DE LA LEY PARA LA TRANSPARENCIA Y ORDENAMIENTO DE LOS SERVICIOS FINANCIEROS."', bold: true}, '\nEn cumplimiento a la citada ley y sus reglamentos, las partes declaran:']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' explicó a ',{ text: '"EL ACREDITADO"', bold: true},' los términos y condiciones definitivas de las cláusulas con contenido financiero, así como las comisiones aplicables, y demás penas convencionales contenidas en este contrato, manifestando el acreditado que dicha explicación ha sido a su entera satisfacción.']},

								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' y el ',{ text: '"EL ACREDITADO"', bold: true},' acordaron libremente modificar los términos y condiciones de la oferta crediticia ajustándolo a satisfacción mutua de las partes.']},

								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' dio a conocer al ',{ text: '"EL ACREDITADO"', bold: true},' el cálculo del costo Anual Total ',{ text: '"CAT"', bold: true},'del crédito correspondiente al momento de la firma de este instrumento.']}
							]
						}
					]
				]
			},

			// ************ Clausulado del contrato **************
			'\nExpuesto lo anterior, los comparecientes celebran el presente contrato de conformidad con las siguientes:\n\n',
			{ // Clausulas
				text: 'C L Á U S U L A S:',
				bold: true,
				style: 'header'
			},
			{
				text:'\n\n'
			},
			{ // Clausula Primera
				text: [
					{ text: 'PRIMERA.- DEFINICIONES; DISCREPANCIA DE DEFINICIONES; ANEXOS.\n', bold: true },
					
					{text: [,{ text: '"Inciso A. "', bold: true},' Definiciones. Los términos definidos a continuación tendrán en el presente Contrato los significados atribuidos a dichos términos en este Inciso:\n']},

					'"Causas de Vencimiento Anticipado": Significa cualquiera de los supuestos previstos con tal carácter en este Contrato.\n',

					'"CONDUSEF": Significa la Comisión Nacional para la Defensa de los Usuarios de Servicios Financieros.\n',

					'"Contrato": significa el presente instrumento, sus anexos y cualquier convenio que lo modifique o adicione.\n',

					'"Costo Anual Total" o "CAT": Significa el costo de financiamiento expresado en términos porcentuales anuales que, para fines informativos y de comparación exclusivamente, incorpora la totalidad de los costos y gastos inherentes a los créditos que otorgan las instituciones de crédito, el cual deberá ser calculado de acuerdo con los componentes y metodología referidos en el numeral M.26.2 de la Circular 2019 de Banco de México y previstos en la Circular 15/2007 de Banco de México.\n',

					{text: ['"Crédito": Es la cantidad de dinero u otro medio de pago  que ',{ text: '"LA ACREDITANTE"', bold: true},' otorga a ',{ text: '"EL ACREDITADO"', bold: true},' conforme a este Contrato, hasta por el importe que se establece en la Cláusula Segunda de este Contrato.\n']},

					'"Día Hábil": Significa cualquier día en que deban estar abiertas al público las Instituciones de Crédito en los Estados Unidos Mexicanos para realizar operaciones, de acuerdo al calendario publicado por la Comisión Nacional Bancaria y de Valores, así como aquellos días del año en que no se requiera que dichas Instituciones de Crédito cierren sus puertas al público y suspendan sus operaciones de acuerdo con las disposiciones que al efecto dicte la Comisión Nacional Bancaria y las demás autoridades competentes.\n',

					{text: ['"Estado de Cuenta": Significa el documento elaborado por  ',{ text: '"LA ACREDITANTE"', bold: true},' en el cual constan los datos sobre identificación del contrato en donde conste ',{ text: '"EL CRÉDITO"', bold: true},' cotorgado, el monto de este vencido no pagado, los saldos insolutos pendientes por vencer; la tasa de interés de',{ text: '"EL CRÉDITO"', bold: true},'aplicables a cada periodo de pago; los intereses moratorios generados, el importe de accesorios generados y los pagos realizados por', { text: '"EL ACREDITADO"\n', bold: true}]},

					'"Impuestos": Significa cualesquiera tributos, contribuciones, cargas, deducciones o retenciones de cualquier naturaleza que se impongan o se graven en cualquier tiempo por cualquier autoridad, incluyendo cualquier otra responsabilidad fiscal junto con intereses, sanciones, multas u otros conceptos derivados de los mismos.\n',

					'"Pesos": Significa la moneda de curso legal de los Estados Unidos Mexicanos.\n',

					'"Seguro de vida": es el seguro que el acreditado está obligado a contratar en términos del presente contrato, y que ampara el pago del adeudo del crédito hasta la suma asegurada contratada, en caso de muerte natural o por accidente.\n',

					'"Seguro de daños": Es un seguro amplio que el acreditado y/o el garante hipotecario, según sea el caso, está(n) obligado(s) a contratar en términos del presente contrato, contra los daños que pueda sufrir el(los) bien(es) sobre el(los) cual(es) se constituye(n) la hipoteca o prenda y que por su naturaleza sean asegurables.\n',

					'"Tasa de Interés Interbancaria de Equilibrio (T.I.I.E.)": por T.I.I.E. se entenderá la tasa que determine el Banco de México para operaciones denominadas en Moneda Nacional, a plazo de 28 (Veintiocho) días, la T.I.I.E. que servirá de base para el cálculo de los intereses será la última publicada previo al inicio del periodo en que se devenguen los intereses respectivos. La cifra promedio ponderado que en cada mes se utilizará estará dada en tanto por ciento con cuatro cifras decimales, tal y como lo da a conocer Banco de México, sin ningún redondeo.\n',

					{text: ['"Unidad Especializada": Significa la unidad especializada de atención a usuarios de   ',{ text: '"LA ACREDITANTE"', bold: true},' , cuyo objeto es atender cualquier queja o reclamación de los clientes, la cual cuenta con el siguiente teléfono lada sin costo ', paramUEAU.telefonoUEAU,', ', paramUEAU.otrasCiuUEAU,', Fax-33-379-802-37 y su correo electrónico de atención es', paramUEAU.correoUEAU,'. Dicha Unidad Especializada cuenta con personal en los Estados de la República Mexicana en los que CONSOL cuenta con Sucursales, cuyos datos podrán ser obtenidos por los clientes en cualquier sucursal de ',{ text: '"LA ACREDITANTE".\n', bold: true}]},

					{text: [,{ text: '"Inciso B. "', bold: true},' Discrepancia en Definiciones. En caso de cualquier discrepancia entre las definiciones contenidas en el Inciso A. de esta Cláusula Primera y cualquier otra estipulación del presente Contrato, prevalecerá esta última, y en caso de cualquier discrepancia entre el  presente Contrato y los Anexos del presente, prevalecerá este Contrato.\n']},

					{text: [,{ text: '"Inciso C. "', bold: true},' Anexos. Los siguientes Anexos se adjuntan e incorporan al presente Contrato por referencia:  ',{ text: 'Anexo "1".\n', bold: true}]},
				
				]
			},
			{text:'\n\n'},
			{ // Clausula Segunda
				text: [
					{ text: 'SEGUNDA.- OTORGAMIENTO DE "EL CRÉDITO".-', bold: true },
					' Por este acto ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' establece en favor de ',
					{ text: '"EL ACREDITADO"', bold: true },
					' un Crédito ',
					{ text: '"REFACCIONARIO"', bold: true },
					' hasta por ',
					generales.montoTotal, '.',
					' Este monto se denominará dentro del presente contrato como ',
					{ text: '"EL CRÉDITO"\n\n', bold: true },

					'Dentro del monto de ',
					{ text: '"EL CRÉDITO"', bold: true },
					'no incluyen las comisiones previstas en este contrato, los intereses más I.V.A., y gastos que deba de cubrir la "EL ACREDITADO", con motivo de las obligaciones contraídas y que se estipulan en el presente instrumento.\n',
					'Para efectos administrativos el presente crédito quedará identificado con el número de crédito establecido en el margen superior derecho de cada hoja de éste contrato de adhesión.\n',
					'El monto del préstamo a que se refiere el párrafo anterior representa el ',
					(parseFloat(generalesAgro.recursoPrestConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2),
					'% de los recursos que requiere ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'para desarrollar el Proyecto, obligándose ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'a realizar con sus propios recursos el segundo concepto y que representa el ',
					(parseFloat(generalesAgro.recursoSoliConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2),
					'% y con recursos de otras fuentes que representa el ',
					(parseFloat(generalesAgro.otrosRecConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2),'%.\n'
				]
			},
			{text:'\n\n'},
			{ // Clausula Tercera
				text: [
					{ text: 'TERCERA.- DESTINO DE "EL CRÉDITO".- "EL ACREDITADO"', bold: true },
					', se obliga a invertir el monto del Crédito otorgado, así como las sumas complementarias que aporte con sus propios recursos, a los fines señalados en el concepto de Inversión que se agrega al presente contrato como Tabla "A". En caso de no hacerlo e independientemente de ser causa de rescisión del presente contrato, ',
					{ text: '"EL ACREDITADO"', bold: true },
					' pagará como pena convencional a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					', una cantidad equivalente a 2 dos veces la tasa de Interés ordinaria más I.V.A. pactada en el punto 1 de la cláusula Quinta del presente contrato.\n\n'
				]
			},
			{ // Tabla A - Proyecto de inversión.
				text: [
					{ text: 'TABLA “A” PROYECTO DE INVERSIÓN', style: 'header', bold: true}
				]
			},
			{
				table: {
					body: creaTablaConcepInversion()
				}
			},
			{text:'\n\n'},
			{ // Clausula Cuarta
				text: [
					{ text: 'CUARTA.- DISPOSICIÓN DEL CRÉDITO.- "EL ACREDITADO"', bold: true },
					'dispondrá del importe del Crédito concedido en éste Contrato de Adhesión de acuerdo al calendario de ministraciones que se agrega al presente contrato como Tabla "B", y a través de la suscripción y entrega de un pagaré múltiple o de pagarés seriados a favor de ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' , cuyo plazo no excederá en ningún caso al de la duración del presente contrato, mismos que contendrán las anotaciones a que se refiere el Artículo 325 trescientos veinticinco de la Ley General de Títulos y Operaciones de Crédito.'
				]
			},
			{ // Tabla B - Ministraciones.
				text: [
					{ text: 'TABLA "B" MINISTRACIONES', style: 'header', bold: true}
				]
				
			},
			{
				table: {
					body: crearTablaMinistraciones(ministraciones)
				}
			},
			{text:'\n\n'},
			{
				text: [
					{ text: '"EL ACREDITADO" ', bold: true },
					'reconoce y acepta que esta disposición se sujeta a los derechos y obligaciones establecidos en el Contrato de Crédito en Escritura Pública Número ________, de Fecha __ de ________ del __ pasada ante la fe del Licenciado ________, Notario Público Número _____ (___), con ejercicio en ________ municipio de ________, del estado de ________. Así también ',
					{ text: '"EL ACREDITADO", "EL GARANTE PRENDARIO (S), GARANTE (S) HIPOTECARIO (S) O USUFRUCTUARIO" ', bold: true },
					'acepta(n) que la(s) garantía(s) descrita(as) en la Cláusula Décima Primera de éste contrato no podrá ser liberada de todo gravamen en tanto no se liquide ésta operación de Crédito al amparo de éste Contrato, tal y como lo establece el contrato de crédito en Escritura Pública ya mencionada al inicio del párrafo; por lo que reconoce la ampliación del plazo de dicha escritura hasta la total liquidación de éste CONTRATO DE ADHESIÓN DE CRÉDITO__.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'faculta de manera expresa a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					'para ceder, descontar, endosar y/o negociar en cualquier forma el presente contrato, pagarés, garantías prendarias e hipotecarias, garantía natural y toda aquella documentación que forme parte del contrato materia del presente crédito, aun antes de su vencimiento, lo anterior ya sea a persona Física o Moral, Pública o Privada.\n\n',

					{ text: '"LA ACREDITANTE"', bold: true },
					'por su parte se obliga a vigilar la inversión de fondos y a cuidar y conservar las garantías otorgadas en los términos del Artículo 327 trescientos veintisiete de la Ley General de Títulos y Operaciones de Crédito, para lo cual ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'le deberá proporcionar todas las facilidades necesarias para dicho fin.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a entregar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en el domicilio señalado en el punto ',
					{ text: 'I ', bold: true },
					'inciso ',
					{ text: 'f ', bold: true },
					'de Declaraciones del presente contrato, dentro de un plazo que no exceda de 30 treinta días naturales siguientes a la fecha en que haya recibido el monto del presente crédito, todas las facturas o documentos que justifiquen fehacientemente los gastos efectuados así como la correcta inversión del Crédito. Los gastos originados por el envío de dichos documentos serán a cargo de ',
					{ text: '"EL ACREDITADO".', bold: true },

				]
			},
			{text:'\n\n'},
			{ // Clausula Quinta
				text: [
					{ text: 'QUINTA.- CONCEPTOS DE COBRO Y MONTOS.-\n', bold: true },
					{ text: '1.- TASA DE INTERÉS.-', bold: true },
					'Los intereses se calculan dividiendo la Tasa de Interés Ordinaria aplicable entre 360, multiplicando el resultado así obtenido por el número de días naturales del mes que corresponda, la tasa que se obtenga conforme a lo anterior, se multiplicará por el saldo del crédito; el cálculo de intereses ordinarios más I.V.A. se efectuará mediante el esquema de “Financiamiento Adicional”, descrito en la cláusula Decima del presente contrato. Las fechas para el cálculo de intereses corresponden a los periodos que conforman la Tabla B MINISTRACIONES de la Cláusula Cuarta y la Tabla C AMORTIZACIONES que se encuentra ubicada en la Cláusula Sexta del presente Contrato.\n',
					'En caso de que el Banco de México, modifique la Tasa de Interés señalada, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a pagar la nueva tasa correspondiente a partir de la fecha en que entre en vigor, tomando como base el instrumento que decrete el Banco de México para estas operaciones de crédito a la tasa que resulte.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					', sin necesidad de requerimiento previo por concepto de intereses los siguientes:'
				],
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{text: [{ text: 'PARA CRÉDITOS DE HABILITACIÓN O AVÍO, ', bold: true},'Intereses ordinarios sobre saldo insoluto a una tasa de 0.0%  (Cero Punto Cero) Por Ciento Anual más I.V.A.']},
					{text: [{ text: 'PARA CRÉDITOS REFACCIONARIOS, ', bold: true},'Intereses ordinarios sobre saldo insoluto a una tasa fija de',{ text: generales.tasaOrdinaria, bold: true},' de acuerdo a lo previsto en los Artículos 9 de la Ley para la Transparencia y Ordenamiento de los Servicios Financieros y 5, fracción V, inciso b) de las Disposiciones de Carácter General en Materia de Transparencia aplicables Sociedades Financieras de Objeto Múltiple, Entidades no Reguladas.\n\n']}
				]
			},
			{
				text: [
					{ text: '2.- INTERESES MORATORIOS .- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no pague puntualmente alguna cantidad que debe cubrir a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'conforme al presente contrato, dicha cantidad devengará intereses moratorios desde la fecha de su vencimiento hasta que se pague totalmente, intereses que se devengarán diariamente, que se pagarán a la vista y ',
					{ text: 'conforme a la tasa de interés ordinaria multiplicada por DOS más I.V.A. ', bold: true },
					'y causará efecto: '
				],
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					'Sobre cualesquiera de los saldos vencidos no pagados oportunamente.',
					'Sobre el saldo total adeudado si éste se diere por vencido anticipadamente y.',
					{text: ['Sobre el importe de otras obligaciones patrimoniales a cargo de ', { text: '"EL ACREDITADO"', bold: true},' que no sean por capital e intereses, si no fueren cumplidas en los términos pactados en este contrato.']},
				]
			},
			{
				text: [
					'Los intereses moratorios en caso de que se causen, junto con los impuestos que generen de acuerdo con las leyes respectivas, deberán pagarse al momento en que se liquide el adeudo.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'manifiesta expresamente su conformidad en el sentido de sujetarse a cualquier otro cambio que determine F.I.R.A. en relación con los porcentajes de descuento y  tasas aplicables a dichos porcentajes.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a que todas las cantidades que deba de pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'tanto de capital como de intereses más I.V.A., los cubrirá en los días señalados, en horas hábiles bancarias y sin necesidad de requerimiento o cobro previo en el domicilio que más adelante se le indica.\n\n'
				],
			},
			{
				text: [
					{ text: '3.- COMISIÓN POR APERTURA DE "EL CRÉDITO".- "EL ACREDITADO" ', bold: true },
					'se obliga a pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'por única vez mientras dure la vigencia de este crédito equivalente ',
					generales.comisionAdmon,
					' del monto de crédito. Para obtener el monto de la comisión a pagar debe multiplicarse el crédito otorgado señalado en la cláusula segunda de este contrato por el ',
					generales.comisionAdmon,
					' equivalente a ',
					generales.montoComAdm,'.\n\n'
				],
			},
			{
				text: [
					{ text: '4.-SEGURO DE VIDA.- ', bold: true },
					'Con el fin de favorecer la cultura financiera y contar con protección económica en caso de fallecimiento',
					{ text: '"EL ACREDITADO" ', bold: true },
					'deberá contratar por su cuenta y orden el Servicio de Seguro de Vida o solicitar el apoyo en su contratación a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					', razón por la cual, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'faculta a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a que efectúe los cobros correspondientes para el pago de las primas que se generen y deslinda a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de cualquier responsabilidad, daño o perjuicio que la Empresa Aseguradora ocasione a “EL ACREDITADO” por falta de indemnización del Seguro de Vida. El costo de prima anual será de ',
					generales.coberturaSeguro,
					' para una suma asegurada de ',
					generales.primaSeguro,
					'. Los detalles del aseguramiento se establecerán en la póliza correspondiente.\n',

					'El seguro de vida ampara a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'ante el fallecimiento por muerte natural durante un año de vigencia a partir de la fecha de expedición de la Póliza de Seguro de Vida emitida por la Empresa Aseguradora. No ampara cobertura por muerte  de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'causada  por enfermedad crónica degenerativa y enfermedad terminal como “Cáncer”, “Diabetes”, “Hipertensión”, Alcoholismo, u otra causa que establezca la Empresa Aseguradora de acuerdo a las Leyes de la República Mexicana que la rigen. La fecha de emisión de la Póliza de Seguro de Vida podrá ser hasta de 30 días posteriores a la fecha de contratación del presente contrato de crédito. El periodo de tiempo entre la contratación de este instrumento de crédito y la fecha de emisión de la póliza, reconoce y acepta ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'que no está protegido por la Cobertura de Seguro de Vida en caso de muerte.\n',

					'El costo de la prima del seguro de vida estará establecido por la Empresa Aseguradora y será descrito en la Póliza de Seguro de Vida que ésta emita. La Forma y términos del contrato de seguro de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'; ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'declara conocerlo y entenderlo, y cuyos derechos se subrogan de manera irrevocable a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'mismos que están descritos en la Autorización que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'otorgue en el Consentimiento “Seguro de Vida Grupo Diversos” o en cualquier otro formato de Solicitud de Seguro de Vida que emita para tal fin la Empresa Aseguradora prestadora del Servicio. La vigencia del Seguro es de un año a partir de la emisión de la póliza de vida por parte de la Aseguradora y el "EL ACREDITADO” autoriza a la “LA ACREDITANTE” el cobro de la prima para que por su cuenta y orden pague a la Aseguradora la cuota correspondiente en los años subsecuentes de vigencia del crédito y/o hasta que se liquide totalmente el saldo insoluto del mismo.\n\n'
				],
			},
			{
				text: [
					{ text: '5.- CAT.- "LA ACREDITANTE" ', bold: true },
					'hace del conocimiento a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'que el ',
					{ text: 'CAT ', bold: true },
					'o ',
					{ text: 'El Costo Anual Total ', bold: true },
					'es de ',
					{ text: generales.CAT, bold: true },
					{ text: 'POR CIENTO ANUAL MÁS I.V.A. ', bold: true },
					'a Tasa Fija y para fines informativos y de comparación exclusivamente.\n\n'
				],
			},
			{
				text: [
					{ text: '6.- GASTOS Y HONORARIOS.- ', bold: true },
					'Todos los gastos, derechos y honorarios, que se causen por el otorgamiento y ejecución de este contrato incluyendo  los gastos de contratación en el Registro Público de Comercio y Registro Público de la Propiedad, sus consecuencias y actos complementarios, así como su cancelación, cuando procedan serán por cuenta de ',
					{ text: '"EL ACREDITADO"', bold: true },
					', quien se obliga a pagarlos en el momento en que se  causen.\n\n'
				]				
			},
			{
				text: [
					{ text: '7.- GARANTÍA FEGA.- "EL ACREDITADO" ', bold: true },
					'está de acuerdo en pagar el costo por concepto de Garantía FEGA que otorga FIRA, el cual representa el 0.00% (Cero punto Cero) por ciento anual más I.V.A. para créditos de ',
					{ text: 'Habilitación o Avío ', bold: true },
					'y el ',
					garantiaFira(catTipoConsultaGarFIRA.refaccionarioFEGA, garantiasFira),
					' anual para créditos ',
					{ text: 'REFACCIONARIOS ', bold: true },
					'multiplicados por el monto del crédito, multiplicados por el periodo de vigencia de cada amortización.\n\n',

					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'dejare de efectuar dichos pagos, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'podrá hacerlos por cuenta del propio ',
					{ text: '"ACREDITADO" ', bold: true },
					'que deberá reembolsarle el importe de los mismos más intereses moratorios más I.V.A. a la tasa estipulada.\n\n'

				],
				
			},
			{ // Clausula Sexta
				text: [
					{ text: 'SEXTA.- PLAZO Y FORMA DE PAGO.- "EL ACREDITADO" ', bold: true },
					'sin necesidad de previo requerimiento, se obliga a pagar a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					'el importe del Crédito dispuesto, los intereses más IVA estipulados y las demás sumas que resulten a su cargo derivadas del presente contrato, en un plazo de ',
					{ text: generales.plazo, bold: true },
					', de acuerdo al siguiente calendario de amortizaciones.\n\n'
				]
			},
			{ // Tabla C - Amortizaciones.
				text: 'TABLA DE AMORTIZACIÓN\n',
				bold: true,
				style: 'header'
			},
			{
				table: {
					body: crearTabla(amortizaciones)
				}
			},
			{ 
				text: [
					'\n\nLas partes convienen que el importe de todos los pagos que realice ',
					{ text: '"EL ACREDITADO"', bold: true },
					', se aplicará en el siguiente orden: Gastos y Costas, Impuestos, honorarios, derechos de registro, cuotas de seguro de vida, intereses moratorios, intereses ordinarios, financiamientos adicionales y por último capital.\n\n',

					'La falta de pago de una de las amortizaciones mencionadas, será causa de vencimiento anticipado y cancelación del presente contrato. No obstante la terminación del plazo, este contrato surtirá plenamente sus efectos legales, hasta que ',
					{ text: '"EL ACREDITADO"', bold: true },
					'haya dado cumplimiento a todas las obligaciones a su cargo.\n\n'
				]
			},
			{ // Clausula Septima
				text: [
					{ text: 'SÉPTIMA.- LUGAR, FORMA DE ENTREGA Y PAGO DE "EL CRÉDITO". "EL ACREDITADO" ', bold: true },
					'pasará personalmente a recoger el importe de su préstamo a las oficinas de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'el cual recibirá mediante cheque o transferencia interbancaria a la cuenta que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'autorice a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'el depósito; o de manos del cajero previa identificación con documento oficial.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'sin necesidad de requerimiento o cobro previo por ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se obliga a pagar en pesos mexicanos a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de conformidad con este contrato y de los pagarés en su caso, el pago de capital, intereses, impuestos, y comisiones de las amortizaciones descritas en la Tabla “C” de este instrumento. Serán pagaderas en la caja o en la cuenta bancaria y en las Sucursales, que para ello determine ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'mediante entregas en efectivo, cheque o transferencia electrónica, pero de estos no se aplicará su importe sino hasta que hubieren sido cobrados.\n',

					'Los pagos que realice ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'serán en las fechas convenidas en días y horas hábiles dentro del horario de atención al público. En caso de que el día de pago fuere día no hábil, la fecha de vencimiento de dicho pago se pospondrá al día hábil inmediato posterior del día en que deba efectuarse el pago de conformidad a la cláusula sexta de este contrato, sin cargo alguno.\n',

					'Cada pago deberá acreditarse de acuerdo al medio de pago que se utilice, de la manera siguiente:'
				]
			},
			{ table: {
				widths: [100, '*'],
				body: [
					[
						{ text: 'Medios de pago:', bold: true },
						{ text: 'Fechas de Acreditamiento del pago:', bold: true },
					],
					[
						{ text: 'Efectivo'},
						{ text: 'Se acreditará el mismo día depositado antes de las 12:00 horas del día'},
					],
					[
						{ text: 'Cheque'},
						{ text: 'Cheque Del mismo banco depositado antes de las 12:00 horas del día, se acreditará el mismo día. Cheque de otro banco, depositado antes de las 12:00 horas, se acreditará a más tardar el Día Hábil siguiente; y después de las 12:00 horas, se acreditará a más tardar el segundo Día Hábil siguiente.'},
					]
				]
				},				
				margin: [0, 20, 0, 0]
			},
			{
				text: [
					'\nLo anterior en el entendido de que en todo caso, las cantidades correspondientes deberán quedar perfecta y absolutamente liberadas y disponibles a satisfacción de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en su cuenta bancaria, a más tardar a las 12:00 (doce) horas (hora de la Ciudad de México, Distrito Federal) del día en que deba hacerse el pago correspondiente, pues de lo contrario, aquellos pagos que efectivamente se hayan acreditado fuera de dicho horario, se considerarán hechos el Día Hábil siguiente, con la consecuente generación de intereses moratorios más I.V.A., en su caso.\n\n',
				]
			},
			{ // Clausula Octava
				text: [
					{ text: 'OCTAVA.- ESTADOS DE CUENTA Y SALDO. "EL ACREDITADO" y "LA ACREDITANTE" ', bold: true },
					'acuerdan que el primero consultará personalmente o vía telefónica con su Ejecutivo de Crédito los saldos o estados de cuenta correspondientes, en las sucursales y/o casa Matriz de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en los horarios que la entidad tiene para la atención al público con un horario matutino de las 8:30 horas a las 14:00 y un vespertino de las 15:30 a las 18:00, de lunes a viernes. Los estados de cuenta podrá consultarlos ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'cada mes según su programa de pagos el cual se establece en la cláusula sexta de este contrato. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'dispondrá de tres días hábiles para objetar o solicitar cualquier aclaración de su saldo.\n\n',

					'Una vez que',
					{ text: '"EL ACREDITADO" ', bold: true },
					'liquide totalmente el saldo insoluto del crédito, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'está obligada a reportar a las Sociedades de Información Crediticias “SICS” a más tardar el día 10 del mes siguiente respecto del mes en el cual se liquidó el crédito, que la cuenta de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'está cerrada sin adeudo alguno.\n\n',

					'En este caso, o para cualquier solicitud, consulta, aclaración, inconformidad y/o queja, relacionada con la operación o servicio contratado ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'podrá llamar o acudir a la ',
					{ text: 'Unidad Especializada de Atención a Usuarios ', bold: true },
					'con domicilio en ',
					paramUEAU.direccionUEAU,
					{ text: ', Tel ', bold: true },
					paramUEAU.telefonoUEAU,
					', ',
					paramUEAU.otrasCiuUEAU,
					{ text: ', Fax. 379 802 37.\n\n', bold: true },
				]
			},
			{ // Clausula Novena
				text: [
					{ text: 'NOVENA.- PAGOS ANTICIPADOS.- "LA ACREDITANTE" ', bold: true },
					'está obligada a aceptar pagos anticipados de los créditos menores al equivalente a 900,000 UDIS, siempre que los Usuarios lo soliciten y  estén al corriente en los pagos exigibles de conformidad con el contrato respectivo. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'podrá hacer pagos anticipados a cuenta de capital, o bien podrá liquidarlo íntegramente antes de su vencimiento, siempre y cuando dicho pago anticipado se presente con un mínimo de un mes de anticipación y sea por una cantidad igual o mayor al pago que deba realizarse en el periodo correspondiente incluyendo la totalidad de refinanciamientos e intereses normales más I.V.A. del último período, entendiéndose por éste, los días transcurridos entre la última amortización realizada y la fecha en que ocurra dicho pago anticipado. ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'aplicará los pagos anticipados al saldo insoluto del crédito. Cada vez que el ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'realice un pago anticipado, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'deberá entregarle un comprobante de dicho pago, en físico, o en electrónico. En caso de que el',
					{ text: '"EL ACREDITADO" ', bold: true },
					'tenga un saldo a favor después de liquidar totalmente el crédito en cuestión,',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'le informará a “EL ACREDITADO” por medio escrito, electrónico o telefónico que tiene un saldo a favor y por lo tanto deberá proporcionar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'los datos de cuenta bancaria para la devolución vía transferencia electrónica bancaria, o bien o bien vía cheque si así lo solicita.\n\n'
				]
			},
			{ // Clausula Decima
				text: [
					{ text: 'DECIMA.- FINANCIAMIENTO ADICIONAL.- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no pudiere cubrir oportunamente sus pagos de intereses más I.V.A., “LA ACREDITANTE” le concederá financiamientos adicionales por los mismos montos de los pagos que tuviere que hacer, con excepción del que coincida con la amortización más próxima de capital, los cuales los cubrirá ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'en las fechas de vencimiento de la amortización de capital más próxima a la fecha del otorgamiento del financiamiento adicional.\n',

					'Las partes convienen en que los financiamientos adicionales, se otorgarán bajo las mismas circunstancias y condiciones crediticias, tanto de tasa, plazo, como de forma de pago de intereses más I.V.A. pactados en el Crédito materia del presente contrato, asimismo, se pacta que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'cubrirá el importe de dichos financiamientos en la fecha de vencimiento de las amortizaciones de capital del Crédito motivo del presente contrato, cuando realice un pago anticipado, a los 365 (TRESCIENTOS SESENTA Y CINCO) días contados a partir de la primera disposición del crédito o a la última fecha en que fueron exigibles estos financiamientos adicionales.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'queda obligado a pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'con sus propios recursos, precisamente el día en que venzan las amortizaciones de capital, los intereses más I.V.A. devengados por los días transcurridos del mes en que ocurran dichos vencimientos, tanto por el crédito inicial al que mencione la cláusula segunda del presente contrato, como por los financiamientos adicionales.\n\n'
				]
			},
			{ // Clausula Decima Primera
				text: [
					{ text: 'DECIMA PRIMERA.- GARANTÍAS.- ', bold: true },
					'En cumplimiento de todas y cada una de las obligaciones derivadas del presente contrato, se constituye a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'las siguientes:'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{text: [ // Garantía específica
						{ text: 'Garantía específica.', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente contrato y de los “Pagarés”, y especialmente para garantizar el pago del Crédito, su suma principal, intereses ordinarios y moratorios más I.V.A., en su caso, comisiones, costos, gastos y todas y cada una de las demás cantidades pagaderas por ', { text: '"EL ACREDITADO" ', bold: true},'a ',{ text: '"LA  ACREDITANTE".\n', bold: true},
						
						{ text: '"EL ACREDITADO"', bold: true},'constituye a favor de ', { text: '"LA ACREDITANTE" ', bold: true},'un gravamen en primer lugar sobre los bienes destino del crédito, tal y como los mismos se describen en los siguientes incisos de la presente cláusula del presente contrato el cual por esta referencia se tienen aquí por reproducidos como si literalmente se insertasen a la letra, y sobre todos los bienes de su empresa, con los frutos y productos futuros pendientes o ya obtenidos, en los términos de los artículos 324, 332, 333, 334, Fracción VII y demás aplicables de la Ley General de Títulos y Operaciones de Crédito, en el entendido de que el valor comercial de los mismos siempre deberá guardar la proporción excedente al saldo insoluto del Crédito, en el porcentaje que el acreditado se obliga a aportar al “Proyecto” de conformidad con lo establecido en la Cláusula Tercera del presente.\n',

						'Esta garantía se extenderá a las garantías y acciones naturales de la empresa, a sus mejoras, a los bienes que en el futuro lleguen a formar parte de la empresa. ', { text: '"EL ACREDITADO" ', bold: true},'será depositario de los bienes gravados en los términos del artículo 329 de la Ley General de Títulos y Operaciones de Crédito.\n\n'
					]},

					{text: [ // Garantía Prendaría.
						{ text: 'Garantía Prendaría. ', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los "Pagares", y especialmente para garantizar el pago del Crédito, su suma principal, intereses ordinarios y moratorios más I.V.A., en su caso, comisiones, costos, gastos y todas y cada una de las demás cantidades pagaderas por ', { text: '"EL ACREDITADO" ', bold: true},'a ',{ text: '"LA ACREDITANTE", "EL GARANTE PRENDARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true},', con el consentimiento (en su caso) de su (s) cónyuge(s), el (los) señor (es): ',{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' constituye(n) a favor de ',{ text: '"LA ACREDITANTE" ', bold: true },' un gravamen en primer lugar sobre el(los) bien(es) mueble(s) descritos a continuación:\n\n',

						creaTablaMobiliarias(garantiasGarantes, catTiposGarantia.prendaria)
					]},

					{text: [ // Garantía Hipotecaria.
						{ text: 'Garantía Hipotecaria. ', bold: true},'En garantía del cumplimiento de todas y cada una de las obligaciones derivadas de este contrato, de los “Pagares” y de la Ley o de resoluciones judiciales dictadas a favor de ', { text: '"LA ACREDITANTE" ', bold: true},'y a cargo de ',{ text: '"EL ACREDITADO"', bold: true},', especialmente el pago de ',{ text: '"EL CRÉDITO"', bold: true},', su suma principal, intereses ordinarios y moratorios más I.V.A., comisiones, gastos y demás accesorios, así como los gastos y costas en caso de juicio, el (los) ',{ text: '"GARANTE (S) HIPOTECARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true},', con el consentimiento (en su caso) de su(s) cónyuge(s), el (los) señor (es): ',{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' constituye(n) a favor de ',{ text: '"LA ACREDITANTE", HIPOTECA EXPRESA EN PRIMER  LUGAR  Y GRADO ', bold: true }, 'sobre el(los) inmueble(s) cuyas características quedan descritas en el párrafo siguiente:\n\n',

						creaTablaMobiliarias(garantiasGarantes, catTiposGarantia.hipotecaria),

						'En dicha hipoteca se comprende todo cuanto enumeran los artículos 2896 y 2897 del Código Civil Federal y sus correlativos del Código Civil de cualquier Estado de la República Mexicana y especialmente el terreno constitutivo del predio, los edificios y cualesquiera otras construcciones existentes al tiempo de hacerse ',{ text: '"EL CRÉDITO" ', bold: true },'o edificados con posterioridad a él; en forma enunciativa y no limitativa sus accesiones naturales y las mejoras hechas, los objetos muebles incorporados permanentemente, la indemnización eventual que se obtenga por seguro en caso de destrucción, garantizando a ',{ text: '"LA ACREDITANTE" ', bold: true },'el pago del capital y de todas las prestaciones e intereses, aunque éstos últimos excedan del término de 3 años, de acuerdo con el artículo 2915 del Código Civil Federal y su correlativo del Código Civil de cualquier Estado de la República Mexicana, de  lo que se tomará razón especial en el Registro Público de la Propiedad respectivo.\n',

						'Con la hipoteca aquí constituida se garantiza el importe total de ', { text: '"EL CRÉDITO" ', bold: true },'y sus accesorios, no obstante que se reduzca la obligación garantizada, por lo cual la ',{ text: '"EL ACREDITADO" ', bold: true },'renuncia expresamente al beneficio de la liberación y división parcial a que se refieren los artículos 2912 y 2913 del Código Civil Federal y sus correlativos del Código Civil de cualquier Estado de la República Mexicana, mismos que manifiestan conocer a la letra, por lo que resulta innecesaria su transcripción literal.\n',

						'La hipoteca que se constituye, permanecerá vigente y subsistente por todo el tiempo en que ',{ text: '"EL ACREDITADO" ', bold: true },'adeude cualquier prestación proveniente del aludido contrato de apertura de crédito simple que se consigna en este instrumento.\n',

						{ text: '"EL ACREDITADO" ', bold: true },'se obliga a notificar a ',{ text: '"LA ACREDITANTE"', bold: true },', cualquier cambio en el nombre de la calle, número oficial, número interior, colonia, Municipio en que se ubique el inmueble materia de la hipoteca, en un término no mayor a veinte días hábiles a partir de que suceda; sin que esos cambios, en caso de darse, impliquen alteración o modificación en forma alguna de la citada garantía hipotecaria.',

						'Sin consentimiento de ',{ text: '"LA ACREDITANTE" ', bold: true },'no podrá darse en arrendamiento el predio hipotecado, ni pactarse pago anticipado de rentas, de acuerdo con el artículo 2914 del Código Civil Federal y su correlativo del Código Civil de cualquier Estado de la República Mexicana.\n\n'
					]},

					{text: [ // Garantía Usufructuaria.
						{ text: 'Garantía Usufructuaria. ', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los “Pagares”, y especialmente para garantizar el pago del Crédito, su suma principal, intereses ordinarios y moratorios más IVA, en su caso, comisiones, gastos y costas y todas y cada una de las demás cantidades pagaderas por ',{ text: '"EL ACREDITADO" ', bold: true },'a ',{ text: '"LA ACREDITANTE"', bold: true },', el (los) ',{ text: '"GARANTE (S) USUFRUCTUARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true },', con el consentimiento (en su caso) de su(s) cónyuge(s), el (los) señor (es): ',{text:textoGarantiasUsufructuaria(garantiasGarantes)},' otorga en custodia a ',{ text: '"LA ACREDITANTE" ', bold: true },'los Certificados Parcelarios expedidos por el Registro Agrario Nacional  RAN, Constancias de Derechos Agrarios de parcelas ejidales y Constancias de Propiedad Ejidal, Documentos Originales que amparan las propiedades descritas en este inciso, a ',{ text: '"LA ACREDITANTE" ', bold: true },'la cual en caso de incumplimiento de  ',{ text: '"EL ACREDITADO"', bold: true },', realizará las gestiones legales y administrativas que permitan el traslado del Derecho Real de Usufructo de dichos bienes, hasta por el tiempo necesario para recuperar todas las prestaciones a que pudiera verse obligado ',{ text: '"EL ACREDITADO" ', bold: true }, 'en caso de incumplimiento de lo estipulado en este contrato. Dichos bienes inmuebles se describen a continuación:\n\n',

						creaTablaGarantiasUsufructuaria(garantiasGarantes),

						'El valor de los bienes que constituyen la garantía hipotecaria, prendaria y/o usufructuaria, aquí consignada deberá guardar en todo tiempo una ', { text: '"Proporción mínima de" ', bold: true },{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) ', bold: true },'en relación con el importe del crédito que se consigna en el presente contrato.\n',

						'Las garantías establecidas en la presente cláusula, no podrán restringirse ni cancelarse mientras que resulte algún saldo a favor de ',{ text: '"LA ACREDITANTE" ', bold: true },' y a cargo de',{ text: '"EL ACREDITADO" ', bold: true },' ya sea por el crédito concedido o demás accesorios pactados, bien porque no haya llegado a su vencimiento, ya porque ',{ text: '"LA ACREDITANTE" ', bold: true },'hubiera otorgado espera y aún porque el adeudo se hubiere documentado en nuevos títulos de crédito.\n\n'
					]},

					{text: [ // Garantía Liquida
						{ text: 'Garantía Liquida: "EL ACREDITADO" ', bold: true},'aporta en garantía liquida un monto de dinero equivalente a ',generales.montoGarLiquida,' el cual corresponde al ', generales.porcGarLiquida, ' por ciento del importe del crédito. El depósito deberá realizarse previo a la ministración del crédito en la cuenta de banco que ',{ text: '"LA ACREDITANTE" ', bold: true },'defina. ',{ text: '"EL ACREDITADO" ', bold: true },'está de acuerdo en que de presentarse algún atraso en cualesquiera de sus amortizaciones, esta garantía se aplicará totalmente como abono al crédito hasta donde alcance su importe, por lo que faculta a ',{ text: '"LA ACREDITANTE" ', bold: true },'para su aplicación sin necesidad de previo aviso a ',{ text: '"EL ACREDITADO".\n', bold: true },

						{ text: '"EL ACREDITADO" ', bold: true },'se obliga solidaria e ilimitadamente en favor de ',{ text: '"LA ACREDITANTE" ', bold: true }, ' por todas y cada una de las obligaciones que deriven del presente contrato, conviniendo expresamente desde este momento, en no invocar por ninguna causa o motivo la división de deuda, renunciando al efecto en cuanto pudiera favorecerle a lo dispuesto por el artículo 1989 mil novecientos ochenta y nueve del Código Civil Federal, aplicable supletoriamente y su correlativo del Código Civil del Estado de Jalisco.\n\n',

					]},
				]
			},
			{ // Clausula Decima Segunda.
				text: [
					{ text: 'DECIMA SEGUNDA.- DEPOSITARIO.- ', bold: true },
					'Designan las partes como Depositario de los bienes pignorados al propio ',
					{ text: '"GARANTE HIPOTECARIO", "GARANTE USUFRUCTUARIO" Y "GARANTE PRENDARIO" ', bold: true },
					'por conducto de, ',
					
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},
					
					' constituyéndose el depósito en los domicilios señalados en sus generales quienes en este acto aceptan el cargo de Depositario y protestan su fiel y legal desempeño.\n\n',

					'El Depositario señala como lugar para la guarda de los bienes pignorados y depositados, el domicilio señalado en la cláusula trigésima tercera y se considerará como Depositario Legal para los fines de su responsabilidad tanto civil como penal, en la inteligencia de que ',{ text: '"LA ACREDITANTE" ', bold: true },', podrá en cualquier momento y sin expresión de causa, revocar el nombramiento del Depositario y en tal caso designará en sustitución del mismo a quien o a quienes estime pertinentes sin necesidad del consentimiento previo del Depositario removido. Los depósitos serán gratuitos.\n\n'
				]
			},
			{ // Clausula Decima Tercera.
				text: [
					{ text: 'DÉCIMA TERCERA.- OBLIGACIONES DE "EL ACREDITADO". "EL ACREDITADO" ', bold: true },
					'se obliga de manera expresa, durante la vigencia del presente contrato a:',	
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Contratar y mantener vigente un seguro sobre los bienes materia de la garantía de este contrato, contra todos los riesgos asegurables, por una suma asegurada que baste a cubrir el importe del crédito y sus accesorios, y en el cual se designe a ',{ text: '"LA ACREDITANTE" ', bold: true },' como beneficiario preferente, debiendo acreditar dicha contratación con la póliza correspondiente dentro de los cinco días hábiles que sigan a la fecha de este contrato.'] },

					{ text: [{ text: '"EL ACREDITADO" ', bold: true },'se obliga a comprobar a ',{ text: '"LA ACREDITANTE" ', bold: true },'con los recibos correspondientes, el pago de las primas relativas en el plazo señalado en el párrafo anterior, quedando facultada ',{ text: '"LA ACREDITANTE"', bold: true },', en caso de omisión de ',{ text: '"EL ACREDITADO"', bold: true },', para dar por vencido anticipadamente el presente contrato.']},

					{ text: ['Permitir que ',{ text: '"LA ACREDITANTE" ', bold: true },'efectúe, en cualquier momento, inspecciones en su unidad de explotación, así como también a exhibir toda la información contable y financiera, facturas, recibos y demás documentos que justifiquen las inversiones realizadas, así como cualquier otra información o documento que se requiera, dentro de un plazo no mayor de 5 cinco días hábiles contados a partir de la fecha en que ',{ text: '"LA ACREDITANTE" ', bold: true },'así lo requiera.']},

					{ text: [
						'Entregar a ',{ text: '"LA ACREDITANTE" ', bold: true },'y satisfacción de la misma, en forma trimestral a más tardar dentro de la última semana del tercer mes correspondiente, en el domicilio señalado en la cláusula Trigésima Tercera del presente contrato, la siguiente información: \n',
						{ text: [' 1.- Información contable\n'] },
						{ text: [' 2.- Información financiera\n'] },
						{ text: [' 3.- Facturas, recibos y demás documentos que justifiquen las inversiones realizadas\n'] },
						{ text: [' 4.- Cualquier otra información o documento que se requiera.\n'] },
						'El que se programe trimestralmente la presentación del informe no exime que la aplicación del crédito se tenga que realizar máximo 30 treinta días después de su disposición.'
					]},

					{ text: ['No vender, dar en arrendamiento ni en explotación ni constituir gravamen alguno sobre los bienes que garantizan el crédito.']},
					
					{ text: ['Deberá cuidar que el valor de los bienes otorgados en garantía en este contrato guarden una proporción, en todo el tiempo de vigencia del presente instrumento, de ',{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) '},' en relación con el monto del crédito otorgado y mientras existan saldos insolutos.']},
					
					{ text: ['Dar las facilidades necesarias para que ',{ text: '"LA ACREDITANTE" ', bold: true },' y/o Los Fideicomisos Instituidos con Relación a la Agricultura (FIRA) para que el personal que éste designe, así como a los representantes de cualquier Institución y Organismo Nacional o Internacional autorizados por “FIRA” proporcione la información respectiva que facilite la inspección que deseen efectuar sobre las inversiones realizadas, proporcionado entre otros, los estados de contabilidad y demás documentos y datos inherentes que dicho fideicomiso solicite.']},
					
					{ text: [{ text: '"EL ACREDITADO" ', bold: true },'no podrá, mientras esté en vigor el presente contrato, contratar ningún crédito sin la previa autorización por escrito de ',{ text: '"LA ACREDITANTE".', bold: true },]},

					{ text: [{ text: '"EL ACREDITADO" ', bold: true }, 'se obliga a “considerar y cumplir con el ordenamiento ecológico y con la preservación y mejoramiento del medio ambiente, la protección de las áreas naturales, la previsión y el control de la contaminación del aire, agua y suelo, así como las demás disposiciones previstas en la Ley General de Equilibrio Ecológico y Protección del Medio Ambiente, vigente a la fecha de la firma del presente contrato, debiendo manejar racionalmente los recursos naturales, acatar las medidas y acciones dictadas por las autoridades competentes, y cumplir con las orientaciones y recomendaciones técnicas de FIRA y/o la persona que cualquiera de ellos designe”.']},

					{ text: ['Informar oportunamente al acreditante de cualquier acto o hecho que pueda afectar la recuperación del financiamiento.\n\n']},
				]
			},
			{ // Clausula Decima Cuarta.
				text: [
					{ text: 'DÉCIMA CUARTA.- ', bold: true },
					'En caso de que ',	
					{ text: '"LA ACREDITANTE" ', bold: true },
					'sea penalizada por la fuente fondeadora debido al incumplimiento a las obligaciones señaladas en la Cláusula Décima Tercera del presente contrato. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'será responsable de todos y cada uno de los gastos y penalizaciones generados. Y bastará con una notificación por escrito que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'envié a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'informándole de los cargos que se realizaran por dicho concepto. Obligándose ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'al pago de los mismos dentro de los siguientes 30 días, de no hacerlo generará el interés ordinario y el interés moratorio más I.V.A. del crédito otorgado hasta su total liquidación.\n\n'					
				]
			},
			{ // Clausula Decima Quinta.
				text: [
					{ text: 'DÉCIMA QUINTA.- RESTRICCIÓN Y DENUNCIA.- ', bold: true },
					'De conformidad con lo dispuesto en el Artículo 294 doscientos noventa y cuatro de la Ley General de Títulos y Operaciones de Crédito, ',	
					{ text: '"LA ACREDITANTE" ', bold: true },
					', se reserva el derecho de restringir el plazo de disposición o el importe del Crédito referido, o ambos a la vez, o para denunciar el presente contrato, mediante simple comunicación por escrito dirigida a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					', quedando en consecuencia limitado o extinguido, según sea el caso, el derecho de ésta para hacer uso del saldo no dispuesto.\n\n'
				]
			},
			{ // Clausula Decima Sexta.
				text: [
					{ text: 'DÉCIMA SEXTA.- INTERVENTOR.- "LA ACREDITANTE"', bold: true },
					', tendrá en todo el tiempo el derecho de designar quien deberá cuidar y vigilar el  cumplimiento de las obligaciones a cargo de ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'que emanen del presente contrato ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a dar a dicho interventor las facilidades necesarias para que éste cumpla con su función, el cual tendrá los derechos y obligaciones que las leyes aplicables establecen.\n\n'
				]
			},
			{ // Clausula Decima Septima.
				text: [
					{ text: 'DÉCIMA SÉPTIMA.- NEGOCIACIÓN DE TÍTULOS.- "LA ACREDITANTE".', bold: true },
					', Tendrá la facultad para negociar con el Banco de México en su carácter de fiduciario del fideicomiso denominado Fondo Especial para Financiamientos Agropecuarios (FEFA) o (FIRA) el presente contrato o títulos de crédito derivado de los financiamientos que otorgue a ',	
					{ text: '"EL ACREDITADO"', bold: true },
					', aun antes de su vencimiento.\n\n'
				]
			},
			{ // Clausula Decima Octava.
				text: [
					{ text: 'DÉCIMA OCTAVA.- TERMINACIÓN ANTICIPADA O CAUSAS DE VENCIMIENTO.- "EL ACREDITADO".', bold: true },
					'reconoce y acepta expresamente que la celebración del presente Contrato y el otorgamiento de ',
					{ text: '"EL CRÉDITO" ', bold: true },
					'por parte de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se basa en la obligación que adquiere ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' de cumplir con todas y cada una de las obligaciones asumidas bajo el presente Contrato, por lo que está de acuerdo en que el incumplimiento de cualquiera de dichas obligaciones, será causa suficiente para que',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'esté facultada para dar por vencido anticipadamente el plazo para el pago de ',
					{ text: '"EL CRÉDITO" ', bold: true },
					'y sus accesorios, sin necesidad de demanda, protesto, reclamación o notificación de ninguna clase. En cuyo caso dichas cantidades serán debidas y pagaderas a la vista, en cualquiera de los supuestos siguientes:\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Incumplimiento de obligaciones de pago.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'no paga puntualmente la suma principal de ',{ text: '"EL CRÉDITO"', bold: true },', los intereses más I.V.A. sobre el mismo o cualesquiera comisiones, costos o gastos que se causen en virtud del presente Contrato.'] },

					{ text: ['Incumplimiento del Contrato.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'ncumpliere con cualquiera de las obligaciones que a su cargo se derivan del presente Contrato Distinta de las de pago, y siempre que dicho incumplimiento no haya sido subsanado en un plazo de cinco (5 Días Hábiles a partir de la notificación del incumplimiento por parte de la ',{ text: '"LA ACREDITANTE" ', bold: true }] },

					{ text: ['Falsedad de información y declaraciones.- Si cualquier información proporcionada a ',{ text: '"LA ACREDITANTE" ', bold: true },'por ',{ text: '"EL ACREDITADO" ', bold: true },'o cualquier declaración de éste en los términos del presente Contrato resultare falsa, o dolosamente incorrecta o incompleta.'] },

					{ text: ['Desvío de recursos.- Si los recursos de ', { text: '"EL CRÉDITO" ', bold: true }, 'se destinaren total o parcialmente a fines distintos a los estipulados en el presente Contrato.'] },

					{ text: ['Condiciones preferenciales.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'otorgare condiciones preferenciales a las de ',{ text: '"EL CRÉDITO" ', bold: true },'con ',{ text: '"LA ACREDITANTE" ', bold: true },'a cualquier otro acreedor bajo cualquier otro financiamiento.'] },

					{ text: 
						[
						'Situaciones de Insolvencia o Intervención.- Si ',{ text: '"EL ACREDITADO:"\n', bold: true },
							{ text: '(i) ', bold: true },'Solicita o fuese solicitada por un tercero, la declaración de concurso mercantil o su equivalente, salvo que dicho procedimiento a juicio de ',{ text: '"EL ACREDITADO" ', bold: true },'fuere notoriamente improcedente, o si ',{ text: '"EL ACREDITADO" ', bold: true },'o cualquiera de sus subsidiarias acudiese a sus acreedores para, de alguna forma, reestructurar sus deudas;\n',

							{ text: '(ii) ', bold: true },'Fuere demandado o sujeto a algún procedimiento ante autoridad judicial o administrativa o de cualquier otro género, que resulte o pudiera resultar en el embargo de bienes o activos, la intervención o subasta de sus bienes, salvo que dicho embargo, a juicio de ',{ text: '"LA ACREDITANTE"', bold: true },', fuere notoriamente improcedente o pudiese ser impugnado por la ',{ text: '"EL ACREDITADO" ', bold: true },'de buena fe con posibilidades de éxito, mediante los procedimientos adecuados.'
						] 
					},

					{ text: ['Expropiaciones y otras contingencias.- Si una parte substancial de los activos de ',{ text: '"EL ACREDITADO" ', bold: true },'fuere objeto de privación de dominio, custodia o control, por expropiación u otro acto similar por parte de cualquier autoridad gubernamental.'] },

					{ text: ['Condenas judiciales o administrativas.- Si en virtud de cualquier procedimiento judicial, laboral o administrativo se dictare sentencia, laudo o resolución en contra de ',{ text: '"EL ACREDITADO" ', bold: true },'o de sus subsidiarias, en su caso, excepto en el caso de que se hayan creado reservas por una cantidad por lo menos igual a la cantidad condenada.'] },

					{ text: ['Contingencias fiscales y administrativas.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'dejare de pagar sin causa justificada cualquier adeudo fiscal correspondiente a su empresa o a sus propiedades, las cuotas o aportaciones correspondientes al IMSS o al INFONAVIT, o al SAR.'] },
					
					{ text: ['Disminución de la Solvencia Económica o Calidad Crediticia.- Si la solvencia o calidad o calificación crediticia de ',{ text: '"EL ACREDITADO" ', bold: true },' o de cualquiera de sus subsidiarias, a juicio de ',{ text: '"LA ACREDITANTE" ', bold: true },'se ve reducida sustancialmente como consecuencia de su participación, de cualquier modo, en cualquiera de los actos a que se refiere el párrafo anterior o en cualquier cesión de activos y/o pasivos.'] },

					{ text: ['Procedimientos en contra.- Si instituye procedimiento judicial o administrativo en contra de ',{ text: '"LA ACREDITANTE" ', bold: true },'de cualquiera de sus subsidiarias o de cualquiera de sus Directores Generales, consejeros, accionistas o empleados.'] },

					{ text: ['Deteriorare las garantías de pago, no guardando una proporción de ',{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) '},' respecto del saldo insoluto del crédito, no las mejore o no efectúe el pago de la suma que se requiera para establecer la necesaria proporción entre dicho valor y el saldo insoluto.'] },

					{ text: 
						[
							'Si abandonara la administración de la empresa o no la atendiere con el debido cuidado y eficiencia a juicio del interventor.\n',
							'En el supuesto de que ',{ text: '"EL ACREDITADO" ', bold: true },' prefiera los servicios profesionales de una persona física o jurídica diferente a ',{ text: '"LA ACREDITANTE" ', bold: true },', deberá cubrir los servicios a ',{ text: '"LA ACREDITANTE" ', bold: true },', quien podrá subcontratar los servicios de terceros, reservándose el derecho de calificar la solvencia moral y técnica de estos.'
						] 
					},

					{ text: 
						[
							'Garantía hipotecaria.- Si ',{ text: '"EL ACREDITADO"', bold: true },':\n',
								{ text: 'i) ', bold: true },' Enajena o grava sin consentimiento expreso y por escrito de',{ text: '"LA ACREDITANTE"', bold: true },', el(los) bien(es) dado(s) en garantía hipotecaria, o si el mismo se rente o se reciben rentas adelantadas;\n',
								{ text: 'ii) ', bold: true },' Si los bienes dados en garantía son objeto de embargo total o parcial;\n',
								{ text: 'iii) ', bold: true },' Si no mantienen en buen estado de conservación los bienes objeto de la garantía;\n',
								{ text: 'iv) ', bold: true },' Si el(los) bien(es) dado(s) en garantía hipotecaria resulta(n) insuficientes si su valor disminuyere con o sin culpa de ',{ text: '"EL ACREDITADO" ', bold: true },'reduciéndose considerablemente su valor posteriormente a la celebración de este contrato, a menos que dicho(s) bien(es) materia de la garantía se sustituya(n) por otro(s) iguale(s) o de mayor valor al(los) otorgado(s) o amplié la garantía a satisfacción de ',{ text: '"LA ACREDITANTE" ', bold: true },'\n',
								{ text: 'v) ', bold: true },' Si efectúa modificaciones al(los) bien(es) dado(s) en garantía sin la autorización previa y por escrito de ',{ text: '"LA ACREDITANTE" ', bold: true },' y de la autoridad correspondiente.\n',
								{ text: 'vi) ', bold: true },' Si ',{ text: '"EL ACREDITADO" ', bold: true },' no asegura el bien dado en garantía o no comprueba estar al corriente en el pago de las primas.\n',
								{ text: 'vii) ', bold: true },'Si no paga durante dos bimestres consecutivos, las contribuciones correspondientes a impuesto predial, derechos por servicio de agua, o cualquier otro impuesto o derecho aplicable por las autoridades al(los) inmueble(s) hipotecado(s).\n',
								{ text: 'viii) ', bold: true },'Si no comprueba a ',{ text: '"LA ACREDITANTE" ', bold: true },' cuando éste así lo solicite, estar al corriente en el pago de los impuestos y derechos mencionados en el inciso precedente.\n'
						] 
					},

					{ text: 
						[
							'Otros supuestos.- Si ocurre cualquier otra Causa de Vencimiento Anticipado prevista por la ley o por el presente Contrato, o en cualquier documento anexo o relacionado con el mismo.\n\n',

							'No obstante lo anterior, ',{ text: '"EL CRÉDITO" ', bold: true },'se extinguirá en los casos previstos por el artículo 301 de la Ley General de Títulos y Operaciones de Crédito. En caso de ocurrir alguna de las causas de vencimiento anticipado antes descritas, ',{ text: '"LA ACREDITANTE" ', bold: true },'podrá declarar por vencido anticipadamente el plazo estipulado para el pago de ',{ text: '"EL CRÉDITO" ', bold: true },'y demás accesorios establecidos en el presente instrumento y ',{ text: '"EL ACREDITADO" ', bold: true },'deberá pagar a ',{ text: '"LA ACREDITANTE" ', bold: true },'de manera inmediata el importe total del saldo insoluto de ',{ text: '"EL CRÉDITO" ', bold: true },'en mención y todas las demás cantidades que se adeuden en términos de este contrato, caso en el cual el o los pagarés que haya suscrito ',{ text: '"EL ACREDITADO" ', bold: true },'en esta fecha vencerán y serán pagados de inmediato; en caso contrario, ',{ text: '"EL ACREDITADO" ', bold: true },'se obliga a pagar intereses moratorios más I.V.A. conforme a lo pactado en la Cláusula Quinta del presente contrato. \n\n'
						] 
					}



				]
			},
			{ // Clausula Decima Novena.
				text: [
					{ text: 'DECIMA NOVENA.- FORMAS DE NOTIFICACIÓN. "LA ACREDITANTE"', bold: true },
					'notificará por escrito en el domicilio que ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'haya señalado para tal efecto, sobre cualquier modificación del presente contrato de adhesión, respecto de la operación o servicio que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' tenga contratado, se le hará saber con cuarenta días naturales de anticipación antes de su entrada en vigor, las nuevas bases de operación. En el evento de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no esté de acuerdo con las modificaciones propuestas, podrá solicitar la terminación del Contrato de Adhesión hasta 60 días naturales después de la entrada en vigor de dichas modificaciones, sin responsabilidad ni comisión alguna a su cargo, debiendo cubrir, en su caso, los adeudos que ya se hubieren generado a la fecha en que solicite dar por terminada la operación o el servicio de que se trate. Una vez transcurrido el plazo señalado sin que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'haya recibido comunicación alguna por parte de “EL ACREDITADO”, se tendrán por aceptadas las modificaciones al Contrato de Adhesión.\n\n'
				]
			},
			{ // Clausula Vigesima.
				text: [
					{ text: 'VIGÉSIMA.- DEL PROCEDIMIENTO DE CANCELACIÓN. ', bold: true },
					'En caso de que ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'quiera cancelar sus operaciones o servicios con la entidad, deberá acudir personalmente con su Ejecutivo de Crédito a entregarle por escrito su solicitud de cancelación, para que este a su vez realice los trámites correspondientes para tal efecto. Para que esto proceda, el cliente acreditará que no tiene saldos pendientes con la entidad sobre ninguno de los rubros que se señalan en este contrato.\n\n'
				]
			},
			{ // Clausula Vigesima Primera.
				text: [
					{ text: 'VIGÉSIMA PRIMERA.- REGLAS PARTICULARES DE EJECUCIÓN.- ', bold: true },
					'En caso de incumplimiento de las obligaciones a cargo de ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					', las partes convienen en que:\n\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['En caso de embargo, ',{ text: '"LA ACREDITANTE" ', bold: true }, 'no se sujetará al orden establecido en los artículos 1395 mil trescientos noventa y cinco del Código de Comercio.'] },
					{ text: [{ text: '"LA ACREDITANTE" ', bold: true },'podrá revocar el nombramiento del Depositario designado en este contrato y, en consecuencia, tomar posesión de los bienes gravados y nombrar depositario de los mismos.'] },
					{ text: ['- El emplazamiento y notificaciones se harán en los domicilios señalados en la cláusula Trigésima Tercera de este contrato.'] },
					{ text: ['- Para la venta o remate de los bienes embargados, servirá de base en primera almoneda, el valor que resulte del avalúo que para ese efecto realice la Institución de Crédito o el perito que designe ',{ text: '"LA ACREDITANTE".\n\n', bold: true }] }
				]
			},
			{ // Clausula Vigesima Segunda.
				text: [
					{ text: 'VIGÉSIMA SEGUNDA.- CONDUSEF.- ', bold: true },
					'El presente contrato se encuentra registrado ante la Comisión Nacional para la Protección y Defensa de los Usuarios de Servicios Financieros (CONDUSEF) con el número de registro ',
					generales.reca,
					', misma que cuenta con el siguiente número telefónico de atención a usuarios (0155-53400999 o LADA sin costo 01800-9998080), dirección en Internet (www.condusef.gob.mx) y correo electrónico (opinion@condusef.gob.mx).\n\n'
				]
			},
			{ // Clausula Vigesima Tercera.
				text: [
					{ text: 'VIGÉSIMA TERCERA.- IMPUESTOS.- ', bold: true },
					'En caso de que conforme a las Leyes fiscales y tributarias, la ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'deba pagar algún impuesto sobre intereses ordinarios, intereses moratorios y/o la comisión por apertura del crédito, ésta se obliga a pagarlo a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'conjuntamente con los referidos conceptos.\n\n'
				]
			},
			{ // Clausula Vigesima Cuarta.
				text: [
					{ text: 'VIGÉSIMA CUARTA.- “EL GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO”.- ', bold: true },
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' ',
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' ',
					generalAvales.cadenaAvales,
					' de manera expresa y voluntaria se constituye(n) mediante este contrato como ',
					{ text: '"GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO" con "EL ACREDITADO" ', bold: true },
					'obligándose solidaria e ilimitadamente entre sí, respecto de todas y cada una de las obligaciones a cargo de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'que se deriven de este contrato, conviniendo desde ahora expresamente en no invocar por ninguna causa ni motivo la división de la deuda, renunciando al efecto en cuanto pudiere favorecerle a los dispuesto en el artículo 1989 del Código Civil Federal y su correlativo del Código Civil de cualquier Estado de la República Mexicana, aplicable supletoriamente.\n\n'
				]
			},
			{ // Clausula Vigesima Quinta.
				text: [
					{ text: 'VIGÉSIMA QUINTA.- DISCREPANCIA EN EL NOMBRE.\n', bold: true },
					
					{ text: '"EL ACREDITADO".- ', bold: true },generales.nombreCliente+aliasCliente(generales.aliasCliente).toUpperCase(),'.\n',
					{ text: '"EL (LOS) GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO".- ', bold: true },
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' ',
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' ',
					generalAvales.cadenaAvales,'.\n\n'
				]
			},
			{ // Clausula Vigesima Sexta.
				text: [
					{ text: 'VIGÉSIMA SEXTA.- DESIGNACIÓN DE PERITO VALUADOR.- “EL ACREDITADO” ', bold: true },
					'autoriza a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a designar un Perito valuador para que determine el valor del(los) bien(es) afectado(s) en garantía hipotecaria, mismo(s) que quedó(aron) descrito(s) en clausulas anteriores de este contrato, llegado el caso que disminuya considerablemente el valor del(los) bien(es) motivo de garantía hipotecaria o que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'proceda para el cobro de los saldos insolutos correspondientes con cargo a ',
					{ text: '"EL CRÉDITO" ', bold: true },
					' que ampara el presente contrato, judicialmente ejercitando la vía ejecutiva mercantil, la hipotecaria, la ordinaria o la que en su caso corresponda.\n\n'
				]
			},
			{ // Clausula Vigesima Septima.
				text: [
					{ text: 'VIGÉSIMA SÉPTIMA.- SEGURO DE DAÑOS.- ', bold: true },
					'Tanto ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'como el(los) ',
					{ text: '"GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO" ', bold: true },
					'se obligan a contratar por su cuenta dentro de los 10 diez días naturales que sigan a la fecha de firma de este instrumento, un seguro amplio contra los daños que pueda sufrir el bien sobre el cual se constituye la hipoteca o prenda y que por su naturaleza sean asegurables, designando como beneficiario preferente e irrevocable a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'debiendo acreditar los términos de dicha contratación a satisfacción de ésta, quedando la póliza respectiva en poder de ',
					{ text: '"LA ACREDITANTE".\n', bold: true },
					
					'El seguro en cuestión deberá corresponder al valor real de construcción asegurable del inmueble hipotecado, de tal manera que en todo momento se encuentren garantizados el capital, intereses más I.V.A. y demás prestaciones y accesorios legales.\n',

					'En la póliza de seguro se hará constar expresamente para los efectos del artículo 109 de la Ley Sobre el Contrato de Seguro, que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'ha obtenido el importe de ',
					{ text: '"EL CRÉDITO" ', bold: true },
					'para destinarlo a los fines indicados en la Cláusula Tercera de este contrato, quedando obligada a dar oportunamente aviso de siniestro a la compañía aseguradora en las formas aprobadas y con copia para ',
					{ text: '"LA ACREDITANTE".\n', bold: true },

					'De dicho contrato de seguro deberá estar vigente y pagada la prima correspondiente en cada renovación, en tanto exista cualquier saldo insoluto a cargo de ',{ text: '"EL ACREDITADO" ', bold: true },'quedando obligado ',{ text: '"EL ACREDITADO" ', bold: true },'a exhibir el o los recibos de pago de la prima correspondiente a este seguro, cada que lo solicite ',{ text: '"LA ACREDITANTE".\n', bold: true },

					'Si ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' no contrata el seguro o deja de pagar las primas correspondientes al mismo, éste faculta a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'para que lo haga por cuenta de éste, quedando obligado a reembolsar las cantidades que se hubieren pagado por su cuenta en un plazo no mayor de 30 treinta días naturales, cubriendo además sobre dichas cantidades, los intereses más I.V.A. que se causen a la tasa moratoria convenida en los términos del presente contrato; en el entendido de que será facultad discrecional de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'optar por contratar o no la póliza de seguro del bien (es) otorgado en garantía.\n',

					'En caso de siniestro, la indemnización que cubra la compañía aseguradora se aplicará a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en pago de las prestaciones que  ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' le adeude hasta donde alcance.\n',

					'En el supuesto de que ya exista seguro sobre el bien en mención, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a llevar a cabo las gestiones necesarias para consignar en la póliza correspondiente como beneficiario preferente de manera irrevocable a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'debiendo entregarle en el plazo convenido en  el primer párrafo de esta Cláusula, la póliza respectiva.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'sabe y acepta que en caso de reclamación y hasta en tanto la aseguradora de que se trate realice el pago de la suma asegurada correspondiente, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'continuará obligada al pago del monto de ',
					{ text: '"EL CRÉDITO" ', bold: true },
					'dispuesto, junto con los intereses más I.V.A. y demás accesorios previstos en este instrumento en los términos y fechas pactadas; en el entendido de que tales obligaciones de pago subsistirán aún en caso de que la compañía aseguradora rechace la reclamación correspondiente y/o decline el pago respectivo; por lo que',
					{ text: '"EL ACREDITADO" ', bold: true },
					'libera a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de cualquier tipo de responsabilidad relacionada con los pagos, procedimientos, montos y plazos del seguro a que se refiere este instrumento, debiendo en su caso ejercitar las acciones que considere necesarias ante la compañía aseguradora correspondiente.\n\n'
				]
			},
			{ // Clausula Vigesima Octava.
				text: [
					{ text: 'VIGÉSIMA OCTAVA.- CESIÓN DEL CRÉDITO.- ', bold: true },
					'Se pacta que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					', si así lo estima conveniente a sus intereses, podrá ceder o en cualquier forma negociar, total o parcialmente, este crédito, sin que por ello, el mismo se entienda renovado en la parte  negociada.',
					{ text: '"EL ACREDITADO" ', bold: true },
					'acepta incondicionalmente la presente previsión, renunciando a ser notificada si la acreedora cediere el crédito a que se refiere este contrato.\n\n'
				]
			},
			{ // Clausula Vigesima Novena.
				text: [
					{ text: 'VIGÉSIMA NOVENA.- CONSULTA DE SALDO Y EMISIÓN DE ESTADOS DE CUENTA.- "EL ACREDITADO"', bold: true },
					', tiene derecho a recibir periódicamente información  relacionada al desglose de los pagos efectuados, En términos del artículo 13, párrafo tercero de la Ley de Transparencia y Ordenamiento de los Servicios Financieros, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'renuncia expresamente a su derecho de recibir un estado de cuenta en su domicilio. Al respecto, las partes en este contrato pactan que en cualquier momento y en la sucursal que corresponda, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'entregará a ',
					{ text: '"EL ACREDITADO"', bold: true },
					', previa solicitud e identificación de esta, un estado de cuenta, en el que de manera clara se indique el monto a pagar en el período, en su caso, desglosado en capital, intereses y cualesquiera otros cargos, las tasas de interés ordinaria y moratoria expresadas en términos anuales simples y en porcentaje, así como el monto de intereses más IVA a pagar, el saldo insoluto de ',
					{ text: '"EL CRÉDITO"', bold: true },
					', el Costo Anual Total (CAT) más I.V.A. y demás requisitos en términos del citado artículo.\n\n'
				]
			},
			{ // Clausula Trigesima.
				text: [
					{ text: 'TRIGÉSIMA.- PROCEDIMIENTO DE ACLARACIONES.- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'tenga alguna queja o aclaración respecto de los movimientos que aparezcan en su estado de cuenta, podrá presentar su aclaración o queja por escrito a través de cualquier sucursal de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'o a través de la Unidad Especializada de Atención al Usuario.\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Cuando la',{ text: '"EL ACREDITADO" ', bold: true }, 'no esté de acuerdo con alguno de los movimientos que aparezcan en el estado de cuenta respectivo podrá objetarlo y presentar una solicitud de aclaración dentro de un término de 15 Quince días naturales contados a partir de la fecha de corte o en su caso, de la realización de la operación. Transcurrido dicho plazo sin haberse hecho objeción a la cuenta, los asientos que figuren en la contabilidad de ',{ text: '"LA ACREDITANTE" ', bold: true },'harán prueba a favor de ésta.'] },
					
					{ text: ['La solicitud respectiva podrá presentarse ante la sucursal en la que se otorgó',{ text: '"EL CRÉDITO"', bold: true },', o bien, en la Unidad Especializada de Atención al Usuario de ',{ text: '"LA ACREDITANTE" ', bold: true },', mediante un escrito, correo electrónico o cualquier otro medio por el que se pueda comprobar su recepción. ',{ text: '"LA ACREDITANTE" ', bold: true },'deberá acusar de recibo de dicha solicitud y proporcionará el número de expediente.'] },

					{ text: ['Tratándose de cantidades a cargo de ',{ text: '"EL ACREDITADO"', bold: true },', este podrá dejar de hacer el pago de los cargos objetados en aclaración, así como el de cualquier cantidad generada con motivo de éstos, en tanto la aclaración no sea resuelta por ',{ text: '"LA ACREDITANTE" ', bold: true }, 'conforme al presente procedimiento. Esta última incluirá los cargos objetados en los estados de cuenta con una leyenda que indique que se encuentran sujetos a un proceso de aclaración.']},
					
					{ text: ['Una vez recibida la solicitud de aclaración, ',{ text: '"LA ACREDITANTE" ', bold: true },'tendrá un plazo máximo de 15 Quince días naturales para entregar a',{ text: '"EL ACREDITADO" ', bold: true },'el dictamen correspondiente, anexando copia simple del documento o evidencia considerada para la emisión de dicho dictamen, el  cual contendrá un informe detallado en el que se respondan todos los hechos contenidos en la solicitud presentada por ',{ text: '"EL ACREDITADO".', bold: true }] },
					
					{ text: ['El dictamen se formulará por escrito y será suscrito por algún funcionario facultado. En el caso de que, conforme al dictamen que emita',{ text: '"LA ACREDITANTE"', bold: true },', resulte procedente el cobro del monto respectivo, ',{ text: '"EL ACREDITADO" ', bold: true },'deberá hacer el pago de la cantidad a su cargo, incluyendo los intereses ordinarios más I.V.A. conforme a lo pactado, sin que proceda el cobro de intereses moratorios más IVA y otros accesorios generados por la suspensión del pago.']},
					
					{ text: 
						[
							'En el término de 15 quince días naturales contados a partir de la entrega del dictamen en mención, ',{ text: '"LA ACREDITANTE" ', bold: true },'se obliga a poner a disposición de  ',{ text: '"EL ACREDITADO" ', bold: true },'en la sucursal donde radica ',{ text: '"EL CRÉDITO"', bold: true },', el expediente generado con motivo de la solicitud, así como a  integrar a este, bajo su más estricta responsabilidad, toda la documentación e información que, deban obrar en su poder y que se relacione directamente con la solicitud de aclaración que corresponda.\n',

							'El procedimiento antes descrito es sin perjuicio del derecho de ',{ text: '"EL ACREDITADO" ', bold: true },'de acudir ante la Comisión Nacional para la Defensa de los Usuario de Servicios Financieros o ante la autoridad jurisdiccional correspondiente. Sin embargo, el procedimiento previsto en esta cláusula quedará sin efectos a partir de que ',{ text: '"EL ACREDITADO" ', bold: true },'presente su demanda ante autoridad jurisdiccional o conduzca su reclamación en términos de la Ley de Protección y Defensa al Usuario de Servicios Financieros.\n\n'
				
						]
					},
				]
			},
			{ // Clausula Trigesima Primera.
				text: [
					{ text: 'TRIGÉSIMA PRIMERA.- ACCIONES.- ', bold: true },
					'Constituida la mora, ',
					{ text: '"LA ACREDITANTE"', bold: true },
					', podrá en cualquier momento proceder al cobro judicial, corriendo por cuenta de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'todos los gastos administrativos y/o judiciales, costas procesales y honorarios profesionales de abogados que se generen por el cobro judicial, dejando establecido que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a elección suya podrá optar por cualquiera de los procedimientos establecidos por las leyes de la materia; en la inteligencia de que si optare por el procedimiento ejecutivo mercantil para exigir el pago de ',
					{ text: '"EL CRÉDITO" ', bold: true },
					'y sus accesorios, ello no implica la pérdida de las acciones reales que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'tiene respecto del bien gravado, conforme a   las estipulaciones de este contrato.\n',

					'En el entendido de que si se sigue dicha vía ejecutiva, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					' podrá señalar los bienes suficientes para su  embargo, sin sujetarse al orden que establece el artículo 1395 mil trescientos noventa y cinco del Código de Comercio.\n\n'
				]
			},
			{ // Clausula Trigesima Segunda.
				text: [
					{ text: 'TRIGÉSIMA SEGUNDA.- AVISOS.- ', bold: true },
					'A menos que en este contrato se estipule lo contrario, las notificaciones o avisos que se contemplan en el mismo, se harán y se enviarán por correo electrónico o se entregarán a cada parte de este contrato en su domicilio, o a cualquier otro domicilio que cualquier parte señale en aviso por escrito dado a las demás partes de este contrato.\n\n'
				]
			},
			{ // Clausula Trigesima Tercera.
				text: [
					{ text: 'TRIGÉSIMA TERCERA.- DOMICILIOS.- ', bold: true },
					'Para oír y recibir todo tipo de notificaciones, las partes, respecto de todos los actos jurídicos que se contienen en este instrumento designan para los efectos legales correspondientes los siguientes domicilios:\n\n',

					{ text: '"LA ACREDITANTE": ', bold: true },paramUEAU.direccionUEAU,'.\n\n',
					{ text: '"EL ACREDITADO": ', bold: true },generales.direccionCliente,'\n\n',
					
					{ text: '"EL (LOS) GARANTE (S) HIPOTECARIO (S), GARANTE PRENDARIO Y AVAL": \n', bold: true },
					
					{text: 
						listaGarantesAvales(listaGarantes, listaAvales)	
					},'\n\n',

					//{ text: '"ADMINISTRADOR GENERAL UNICO.-" \n', bold: true },
					// { text: '"CONSEJO DE ADMINISTRACCIÓN.-" \n', bold: true }

					'Tanto ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'como el(los) ',
					{ text: '"GARANTE(S) HIPOTECARIO(S), PRENDARIOS Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true },
					', deberán informar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'del cambio de su domicilio, por lo menos con 10 diez días hábiles de anticipación. En caso de no hacerlo, todos los avisos, notificaciones y demás diligencias judiciales o extrajudiciales que se hagan en el domicilio indicado por las mismas, en esta cláusula, surtirán plenamente sus efectos.',

					'En el domicilio señalado por',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se encuentra la Unidad Especializada de Atención a Usuarios, mediante la cual ',
					{ text: '"EL ACREDITADO" ', bold: true },
					', podrá solicitar aclaraciones, consultas de saldo, movimientos, entre otros. El correo electrónico de dicha Unidad es ',
					paramUEAU.correoUEAU,
					' con domicilio en ',
					paramUEAU.direccionUEAU,
					', Teléfono 01 33 379 820 00, o lo podrá hacer directamente en cualquier sucursal de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'que exista en la República Mexicana.\n\n'
				]
			},
			{ // Clausula Trigesima Cuarta.
				text: [
					{ text: 'TRIGÉSIMA CUARTA.- TÍTULOS DE LAS CLÁUSULAS.- ', bold: true },
					'Los títulos de las cláusulas que aparecen en este contrato, se han puesto única y exclusivamente para facilitar su lectura, por lo tanto, no definen ni limitan el contenido de las mismas. Para efectos de interpretación de cada cláusula, las partes deberán atenerse exclusivamente a su contenido y de ninguna manera a su título.\n\n'
				]
			},
			{ // Clausula Trigesima Quinta.
				text: [
					{ text: 'TRIGÉSIMA QUINTA.- MODIFICACIONES.- ', bold: true },
					'Cualquier modificación, adición o aclaración a los términos del presente contrato sólo podrán llevarse a cabo previo acuerdo entre ',
					{ text: '"LAS PARTES".\n\n', bold: true }
				]
			},
			{ // Clausula Trigesima Sexta.
				text: [
					{ text: 'TRIGÉSIMA SEXTA.- TÍTULO EJECUTIVO.- ', bold: true },
					'De conformidad con lo dispuesto por los artículos 87-E y 87-F de la Ley General de Organizaciones y Actividades Auxiliares del Crédito, el presente contrato conjuntamente con el estado de cuenta certificado por el Contador de ',
					{ text: '"LA ACREDITANTE"', bold: true },',  será título ejecutivo, sin necesidad de reconocimiento de firma ni de ningún otro requisito.\n\n'
				]
			},
			{ // Clausula Trigesima Septima.
				text: [
					{ text: 'TRIGÉSIMA SÉPTIMA.- LEGISLACIÓN APLICABLE, INTERPRETACIÓN Y JURISDICCIÓN.- ', bold: true },
					'En relación a la interpretación, ejecución y  cumplimiento del presente contrato, éste se regirá e interpretará de acuerdo a las Leyes de los Estados Unidos Mexicanos, particularmente por lo previsto en la Ley General de Títulos y Operaciones de Crédito y  sus Leyes Supletorias.\n\n'		
				]
			},
			{ // Clausula Trigesima Octava.
				text: [
					{ text: 'TRIGÉSIMA OCTAVA.- JURISDICCIÓN.- ', bold: true },
					'Para la interpretación y cumplimiento del presente contrato, así como para el caso de cualquier controversia, litigio o reclamación de cualquier tipo, en contra de cualquiera de las partes de este contrato, todos aceptan someterse expresamente a la jurisdicción y competencia de los tribunales competentes del Trigésimo primer partido judicial con sede en la cabecera municipal de Tlajomulco de Zúñiga o de la ciudad de Guadalajara, Jalisco, renunciando clara y terminantemente al fuero que la ley concede, pudiendo ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'elegir de conformidad con la jurisdicción concurrente el fuero local o federal para dirimir cualquier controversia derivada del presente contrato. Todas las controversias que surjan con motivo del presente contrato de adhesión deberán ser resueltas con base en lo señalado en la Ley de Transparencia y Ordenamiento de los Servicios Financieros. Ley de protección y defensa al usuario de servicios financieros y demás relativas y supletorias que la misma ley señala, siendo la comisión nacional, la competente para resolver su aplicación e interpretación.\n\n',

					'Para la interpretación y cumplimiento del presente contrato, se deberá sujetarse a lo dispuesto en el Código de Comercio, la Ley de Títulos y Operaciones de Crédito y demás leyes mercantiles aplicables, y se aplicará supletoriamente a los ordenamientos mencionados solamente en el caso y a falta de disposiciones expresas el Código Civil Federal aplicado en forma supletoria.\n'
				]
			},
			{ // Generales
				text: 'G E N E R A L E S',
				bold: true,
				style: 'header'
			},
			{
				text: [
					'Los que suscriben el presente contrato manifiesta ser: ',
					generales.nomApoderadoLegal,
					' declara por sus generales ser mexicano por nacimiento, nació el ',
					generales.fechaNacRepLegal,
					' con domicilio en calle ',
					generales.direcRepLegal,
					'. Quien se identifica con credencial de elector folio ',
					generales.identRepLegal,
					'.\n'
				]
			},
			{ // Tabla Generales
				table: {
					body: crearTablaIntegrantes(tablaIntegrantes, integrantes)
				}
			},
			{
				text: [
					'Las partes manifiestan que en la celebración del presente contrato no ha existido ningún vicio del consentimiento, que pudiera ser causa de nulidad o rescisión de este contrato y si lo hubiere, desde este momento renuncian a la acción de nulidad que les pudiere corresponder, en testimonio de lo anterior, y conformes ',
					{ text: '"LAS PARTES" ', bold: true },
					'de que la carátula de este instrumento y las cláusulas anteriores son complementarias e integrantes de un mismo instrumento se firma por',
					{ text: '"LAS PARTES" ', bold: true },
					', por triplicado en Tlajomulco de Zúñiga, Jalisco a los ',
					{text: generales.fechaIniCredito, bold: true },
					'.\n\n'
				]
			},
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
					'POR "EL ACREDITADO"',
					'\n',
					'\n',
					'___________________________________',
					generales.nombreCliente+aliasCliente(generales.aliasCliente),
					generales.direccionCliente
				],
				bold: true,
				alignment: 'center'
			},
			{
				
				stack: [
							'\n\n',
							{ text:' POR "EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)"', bold: true },
				        	firmantesGarantes(listaGarantes)
				        ],
				alignment: 'center',
				pageBreak: 'before'

				
			},
			{
				
				stack: [
							'\n\n\n',
							{ text:' POR "EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true },
				        	firmantesGarantes(listaAvales)
				        ],
				alignment: 'center'

				
			},
			{
				
				stack: [
							'\n\n\n',
							{ text:' “LOS TESTIGOS”', bold: true },
				
				        	firmantesGarantes(listaUsuarios)
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

var tablaIntegrantes = [
	[
		{ text: 'NOMBRE', bold: true },
		{ text: 'RFC.', bold: true },
		{ text: 'DOMICILIO', bold: true },
		{ text: 'FOLIO IFE (INE)', bold: true }
	]
];

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

function crearTabla(amortizaciones) {
	var tablaAmortizaciones = [
		[{ text: 'NUMERO', bold: true, style: 'header'}, { text: 'FECHA DE AMORTIZACIÓN', bold: true, style: 'header'}, { text: 'MONTO A AMORTIZAR A CAPITAL', bold: true, style: 'header'}]
	];

	if(amortizaciones != null){
		amortizaciones.forEach(function(amortizacion) {
			tablaAmortizaciones.push([{ text: amortizacion.amortizacionID, alignment: 'center'},
									amortizacion.fechaExigible,
									amortizacion.montoCuota]);
		});
	}

	tablaAmortizaciones.push([{ text: ' ', bold: true, style: 'header'}, { text: 'Total', bold: true, style: 'header'}, { text: generalesAgro.montoDeuda, bold: true}]);

	return tablaAmortizaciones;
}

function aliasCliente(parAlias){
	var texto = '';

	if(parAlias != ''){
		texto = '\nTambién conocido (a) indistintamente con el (los) nombre (s) de: '+parAlias;
	}

	return texto;
}

function creaTablaMobiliarias(par_garantias, par_tipoGarantia) {
	var var_garantia = '';

	if(par_garantias != null){
		for (i=0, len = par_garantias.length; i < len; i++) {
			if(par_garantias[i].garTipoGarantia == par_tipoGarantia){
				var_garantia += ' - ';
				var_garantia += par_garantias[i].garObservaciones;
				var_garantia += '\n\n';
			}
		}
	}

	return var_garantia.substring(0,1).toUpperCase()+var_garantia.substring(1).toLowerCase();
}

function creaTablaInmobiliaias(par_garantias) {
	var var_garantia = '';

	if(par_garantias != null){
		for (i=0, len = par_garantias.length; i < len; i++) {
			if(par_garantias[i].tipoGarantia == 'Garantia Hipotecaria'){
				var_garantia += par_garantias[i].observaciones;
				var_garantia += '\n\n';
			}
		}
	}
	
	return var_garantia.substring(0,1).toUpperCase()+var_garantia.substring(1).toLowerCase();
}

function listaGarantesAvales(par_listaGartante, par_listaAvales){
	var var_lista = [];
	
	if(par_listaGartante != null){
		for (i=0, len = par_listaGartante.length; i < len; i++) {
			var_lista.push({ text: par_listaGartante[i].nombre+'.- ', bold: true });
			var_lista.push({ text: par_listaGartante[i].domicilio+'\n'});
		}
	}

	if(par_listaAvales != null){
		for (i=0, len = par_listaAvales.length; i < len; i++) {
			var_lista.push({ text: par_listaAvales[i].nombre+'.- ', bold: true });
			var_lista.push({ text: par_listaAvales[i].domicilio+'\n'});
		}
	}

	return var_lista;
}

function crearTablaIntegrantes(tablaIntegrantes, integrantes) {
	tablaIntegrantes = [
		[
			{ text: 'NOMBRE', bold: true },
			{ text: 'RFC.', bold: true },
			{ text: 'DOMICILIO', bold: true },
			{ text: 'FOLIO IFE (INE)', bold: true }
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

function garantiaFira(par_tipoConsulta, par_lista){
	var var_porcentaje;
	
	
	if(par_lista != null){
		for (i=0, len = par_lista.length; i < len; i++) {
			
			if(par_tipoConsulta == catTipoConsultaGarFIRA.refaccionarioFEGA && par_lista[i].clasificacionID == catSubClasificaCred.refaccionario && par_lista[i].tipoGarantiaID == catGarantiaFira.FEGA){
				var_porcentaje = par_lista[i].porcentaje;
			}else if(par_tipoConsulta == catTipoConsultaGarFIRA.refaccionarioFONAGA && par_lista[i].clasificacionID == catSubClasificaCred.refaccionario && par_lista[i].tipoGarantiaID == catGarantiaFira.FONAGA){
					var_porcentaje = par_lista[i].porcentaje;
				}else if(par_tipoConsulta == catTipoConsultaGarFIRA.avioFEGA && par_lista[i].clasificacionID == catSubClasificaCred.avio && par_lista[i].tipoGarantiaID == catGarantiaFira.FEGA){
					var_porcentaje = par_lista[i].porcentaje;
					}else if(par_tipoConsulta == catTipoConsultaGarFIRA.avioFONAGA && par_lista[i].clasificacionID == catSubClasificaCred.avio && par_lista[i].tipoGarantiaID == catGarantiaFira.FONAGA){
						var_porcentaje = par_lista[i].porcentaje;
					}
		}
	}	

	return var_porcentaje;
}

function crearTablaMinistraciones(par_ministracion) {
	var tablaMinistracion = [
		[{ text: 'MINISTRACIONES', bold: true, style: 'header'}, { text: 'FECHA', bold: true, style: 'header'}, { text: 'CANTIDAD', bold: true, style: 'header'}]
	];

	if(par_ministracion != null){
		par_ministracion.forEach(function(ministracion) {
			tablaMinistracion.push([{ text: ministracion.numeroMinistracion, alignment: 'center'},
									ministracion.fechaMinistracion,
									ministracion.capitalMinistracion]);
		});
	}

	tablaMinistracion.push([{ text: ' ', bold: true, style: 'header'}, { text: 'Total', bold: true, style: 'header'}, { text: generales.montoTotal, bold: true}]);

	return tablaMinistracion;
}

function creaTablaConcepInversion(){
	var var_conceptos = [];
	var var_porcentajeRP = (parseFloat(generalesAgro.recursoPrestConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2);
	var var_porcentajeRS = (parseFloat(generalesAgro.recursoSoliConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2);
	var var_porcentajeROF = (parseFloat(generalesAgro.otrosRecConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2);

	var var_consulta = {
		'solicitudCreditoID': generalesAgro.solicitudCreditoID,
		'clienteID': $('#clienteID').val(),
		'tipoRecurso': 'P'
	};

	var var_tablaConceptos = [
		[{ text: 'CONCEPTO', bold: true, style: 'header'}, { text: 'No. UNIDADES', bold: true, style: 'header'}, { text: 'UNIDAD', bold: true, style: 'header'},{ text: 'MONTO ($)', bold: true, style: 'header'}]
	];

	var_tablaConceptos.push([{ text: 'Con Recursos del Préstamo:', bold: true, style: 'header'}, { text: '', bold: true, style: 'header'},{ text: '', bold: true, style: 'header'}, { text: '', bold: true}]);

	conceptosInversionAgroServicio.listaConcetosInv(var_consulta,  1,{ async: false, callback:function(conceptos){
		if(conceptos != null){
			conceptos.forEach(function(concepto) {
				var_tablaConceptos.push([{ text: concepto.descripcionRP},
											{ text: concepto.noUnidadRP,alignment: 'right'},
											{ text: concepto.unidadRP,alignment: 'center'},
											{ text: concepto.montoInversionRP,alignment: 'right'}]);
			});
		}
	}});
	
	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: 'Total Crédito', bold: true, style: 'header'},{ text: var_porcentajeRP+'%', bold: true, style: 'header', alignment: 'right'}, { text: parseFloat(generalesAgro.recursoPrestConInv).toFixed(2), bold: true, alignment: 'right'}]);
	var_tablaConceptos.push([{ text: 'Con Recursos del Acreditado:', bold: true, style: 'header'}, { text: '', bold: true, style: 'header'},{ text: '', bold: true, style: 'header'}, { text: '', bold: true}]);

	var_consulta.tipoRecurso = 'S';
	conceptosInversionAgroServicio.listaConcetosInv(var_consulta,  2,{ async: false, callback:function(conceptos){
		if(conceptos != null){
			conceptos.forEach(function(concepto) {
				var_tablaConceptos.push([{ text: concepto.descripcionRS},
											{ text: concepto.noUnidadRS,alignment: 'right'},
											{ text:concepto.unidadRS,alignment: 'center'},
											{ text: concepto.montoInversionRS,alignment: 'right'}]);
			});
		}
	}});

	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: 'Total Aportación', bold: true, style: 'header'},{ text: var_porcentajeRS+'%', bold: true, style: 'header', alignment: 'right'}, { text: parseFloat(generalesAgro.recursoSoliConInv).toFixed(2), bold: true, alignment: 'right'}]);
	var_tablaConceptos.push([{ text: 'Con Recursos de Otras Fuentes:', bold: true, style: 'header'}, { text: '', bold: true, style: 'header'},{ text: '', bold: true, style: 'header'}, { text: '', bold: true}]);

	var_consulta.tipoRecurso = 'OF';
	conceptosInversionAgroServicio.listaConcetosInv(var_consulta,  3,{ async: false, callback:function(conceptos){
		if(conceptos != null){
			conceptos.forEach(function(concepto) {
				var_tablaConceptos.push([{ text: concepto.descripcionOF},
											{ text:concepto.noUnidadOF,alignment: 'right'},
											{ text:concepto.unidadOF,alignment: 'center'},
											{ text: concepto.montoInversionROF,alignment: 'right'}]);
			});
		}
	}});

	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: 'Total Otras Fuentes', bold: true, style: 'header'},{ text: var_porcentajeROF+'%', bold: true, style: 'header', alignment: 'right'}, { text: parseFloat(generalesAgro.otrosRecConInv).toFixed(2), bold: true, alignment: 'right'}]);

	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: '', bold: true, style: 'header'},{ text: 'Total del Proyecto', bold: true, style: 'header'}, { text: parseFloat(generalesAgro.montoTotConcepInv).toFixed(2), bold: true, alignment: 'right'}]);

	return var_tablaConceptos;
}

function textoGarantiasPorTipo(par_garantias, par_tipoGarantia){
	var var_textoGarantias = [];
	
	if(par_garantias != null){
		for (i=0, len = par_garantias.length; i < len; i++) {

			if(par_garantias[i].garTipoGarantia == par_tipoGarantia && par_garantias[i].garTipoPersona == 'F'){
				var_textoGarantias.push({ text: par_garantias[i].garNombreGarante, bold: true});

				if(par_garantias[i].garAlias != ''){
					var_textoGarantias.push({ text: ',  también conocido (a) indistintamente con el (los) nombre (s) de '});
					var_textoGarantias.push({ text: par_garantias[i].garAlias});
				}

				var_textoGarantias.push({ text: ', '});
			}
		}
	}

	return var_textoGarantias;
}

function textoGarantiasUsufructuaria(par_garantias){
	var var_textoGarantias = [];
	
	if(par_garantias != null){
		for (i=0, len = par_garantias.length; i < len; i++) {

			if(par_garantias[i].garUsufructuaria == 'S' && par_garantias[i].garTipoPersona == 'F'){
				var_textoGarantias.push({ text: par_garantias[i].garNombreGarante});

				if(par_garantias[i].garAlias != ''){
					var_textoGarantias.push({ text: ',  también conocido (a) indistintamente con el (los) nombre (s) de '});
					var_textoGarantias.push({ text: par_garantias[i].garAlias});
				}

				var_textoGarantias.push({ text: ', '});
			}
		}
	}

	return var_textoGarantias;
}

function creaTablaGarantiasUsufructuaria(par_garantias) {
	var var_garantia = '';

	if(par_garantias != null){
		for (i=0, len = par_garantias.length; i < len; i++) {
			if(par_garantias[i].garUsufructuaria == 'S'){
				var_garantia += ' - ';
				var_garantia += par_garantias[i].garObservaciones;
				var_garantia += '\n\n';
			}
		}
	}

	return var_garantia.substring(0,1).toUpperCase()+var_garantia.substring(1).toLowerCase();
}

var logoConsol = 'data:image/jpeg;base64,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8FHgTihT5FDotWQQQKterRuSjxJxR3DxQQLWlft4q8ndjN8FJtG6mUIY/wB2KvMmaUPQ9tpBG3wwv3mrD0ND1QQkrdo9DZWtaBjm8BC9v60qxXiTDrajNkhHsXqy1Hpuv/uQxpelWK/BybTlHGcHq2Wjo2SktCHft7VYr0gSvavYr0KZ4mMLZjVSPoNPlHC83/A8l96sV6JtpQle/AqjG270aWYnXI0vwVYr1Y0o+MJ3s7Ud52oTveWi2I+z4EeyJ8VWK/ImVDdb89WK/wAyrFf5lWGcP5iNzz0nSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpQkVf4IOop/M2222222222222zDh/2Yf/EACsQAQACAAQEBgMBAQEBAAAAAAEAESExQWEQUXGBIJGhscHwMEDR4fFQYP/aAAgBAAABPxCYcZvSKW1tly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXEbVSp83FYukuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cueq4rH0ly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1PFYuhLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLnquL8oly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1fFeUS5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly/AS8gly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLl+AH5RLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLmPiH5BLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXL8GLyiXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuX4EflEuXLly5cuXLly5cuXLly5cuXLgdg7BOZvJmeuDUMyUEfJMtdM78QsxQPNeZGgZhPS5kyeWD3gNkHUbly5cuXLly5cuXLly5cuXLly5cV/ZlxXkkuXLly5cuXLly5cuXLly4sugB3UXYI5l+kuqJywvSKq0q6sCBAgQIQHhBq1OaqV2AmhuYIzzxEB7BePlLly5cuXLly5cuXLly5cuXPtbcV5ZLly5cuXLly5cuXLly46A9VUtm9C/wBR5xHagIECBAgQIECBAh4wFU2YPMlUNDT+5Rrbpk85dl3hLly5cuXLly5cuXLly59Lbi/JJcuXLly5cuXLly5camDNWglh5AHQ1lmxpbgdCBAgQIECBAgQIECEEHjAMMI5/UErugLB6MuXLly5cuXLly5cuXPtbcV5ZLly5cuXLly5cuXDFPJ+TlL7WcsAQgQIECBAgQIECBCCCCDxjmGGGKm3lOZ0mK0ampLly5cuXLly5cuXPrbcV5ZLly5cuXLly5cUIAFq6R2xRk/z/YqiKs1zYEIEIECBAgQIECBCCCCCDwgYYYYYYJIDlK+r0mXLly5cuXLly5c+jtx9CS5cuXLly5cuAhzyxRYGWrcwhCEBXVrcG/0Q/wCRLYLEYwIECBAgQIQQQQQeE7DDDDCRIlSik2P7ly5cuXLly5cufd24+jJcuXLly5cuCH9VsT26i/2EIQhD5r3ghmD1iBAgQIIEDiBBBJB4HYZYeIEgiR6JemF2WZMuXLly5cuXPu7cX5JLly5cuXLldxWs9gAz+8CEIQg897wwS77GoECBBBBB4QAgkk4LLLL4QAIII6Fx5LFy5cuXLly59nbivIJcuXLly4LiAtXQl4UfDz3YQhCEIQ/U1hhm4kPrCCBBBBBB4QEk49l8NQEEEEEEylx1vtLly5cuXLn09uK8p7S5cuXLlyw5aNXlwIQhCEJl9UMM6zE8AEEEEEHiAU4D4aAIIIIIOBwbMyY2czfeXLly5cuff24vyEuXLly5hi0tvNlqqtrmwhCEIQhMvqhhguZKIFYeACCCCCHwwp4waBBBBBBxMxk9ZkExcuXLlz0v24MXkJcuXLjo0FrMkZwHI0hCEIQhCEy+rhMN4c5tmvXwgOAwwQeEsfBsEMMEHAPAGYmcnZly5cuXPT/bgxeU9pcuXLlsMfI6HAhCEIQhCZfVx9M70fPGH4geIeBfKThmGCD8MAxwbJYGTDqly5cuej+3H0j2ly5cU2hVmYy76cSEIQhCE914NZfy4Bc5VBSOOa/xwA8GInR76S5cuXPSfbivIe0uXLlxsW+g4kIQhCEITL6vBqdqeT+AAo4ovBY+DA44/wAAB4FrEznOtMesuXLnontx+s5S5cuVA2nYOJCEIQhCEy+qOOOX8mvy8IKKNlyW/qdpfnMXhLUXgWfPxxwDLGAHcwiiii8AYxlCtcEuXLnpXtxf0NJcuc6krrLvHXiQhCEIQhHh6ooo5tFPnhwKKKKOqQ5n3hACCgyEXznwgLMBDBChQZDgfBQDKkldwzD1PtFFFFFFwMYzkqOPSXLlz0L24/acpcuVq43PQhDgQhCEIQhHg6ooo52u8jCDFFFE0TA5v5AAABQGk9Ax8w+AFqmhyPrKAAFBkEwrwWWV6ZI40Q6632iiiiiii8DGM3cJcuene3F/c0ly5yZE88YQhwIcSEIRYOqOPgbjqKKDCJqu75EAoCgMgg3PQMfMOIKBJnX6wgAAFBlXC48Bhw2SJ9ejQ4uut9uAooooosWLFjwALlz0r24r6mkuXOVGE8JCEIQhCLF1RxcLJ80ekqycmoMxOJ/gIMAVAacQ9anmCEOaTM2u7AKCsOKpeC9ZVATHtf8AAHgddV7cQUWKLFixYsZTzhcuXPRPbj9hylxoXljLm1T4SEIQhCEWOFFwsYmxT95d7I6mxA1CoDwAV7S9piTzYuQc393+Qy8DqByzqAmHzsjY8LrqPaMLFixYsWLFjFnUAy5c9E9uK+5pLli5P2hjwIcCHEhCDHj6oo+IBWI2+A3gEBUB4cDzr7S3my103f5C3hXwoANcZhZB0Njw3MM0s9IwsWLFixYsWLFlW41Llz0D24v6mkuVLvhlwPEQgwhFiheAKr8P6KkkX4rjLNn0MIwwsWLFixYsWLFXQS5c9K9uGsf2NJcxjvhl4SHA4EGEeKFF+MD6VJJJJPB7LLDwgMLFixYsWLFixYoLlz0L24ZEpE5ZlVtG0BEzHOYBzftDI4kIeAhCDFihRRfiK/lJJJJPB7LLLN0BYsWLFixYsWLFmOS5c9A9vA82XAHeDFVPIe2sf2SIUn4yDFjgfyAAsgQSSeL93xlm3qosWLFixYsWMWLDe0LLlz0/28NS9erAldJznPlbaPRyYtz6UngeIYMI8fAD+QBVATfCTwgYZd/Bv6zFixYsWLFixYsWG+QJcuen+3jqOdA64nRzJgqFxGh0TGeg8z3mNdvsdBO6ekvwDBixQoMHiBAZSFtQ/wACH+RD/Igf8YH/AAh/lQ/wof5UP8Kf8mEAZFnHZYYYv67FixYsWLFixYsWVc8y5c9B9vxVKiWU5QxWPta95VgMcp+GIirOo8SPFAwYMHiHmWDBgy4MuXLly5V3eIwwwxd1mLFixYsWLFixYso+tXLlz0n2/O40wpidHSVl1zMO39S4t0Ri6OTCKQYMIIII8wQZcuXBly5fBco7/gDDLNz3y4sWLFiy4sWLN6GXXSXLivpfb9HNh5aGcxFzn8kHYsF5DmOsGEEEEEecIMGXLl8Fy5cuUd7wFllmx75cuXFlxYsuLLlqejCXLlz0P2/TVKHPM3HSJlVcK47f6gwYMII86QZcuXLly5cuXPWOHr4HgMXPdLlxZcWLFly+FI1cWXLlz0H2/UemBSJgkXYoUC7/AMhAwgZ5ggy5cuXLly5cuPwgMsXPdLly5cWXLly5UGhiy/B6T7fqoIiWOZGgq42MTuRBFPf8zOXSjgmjBnmCDLly5cuXLly4vW8YGN3S5cuXLl8LlzEHPFLly5c9D9v2CXYkrzEvleh084xIA/4M5iKJSYIy5cuXLly5cuPxoGJ3S5cuXwuXLmcZMWXLly5c9H9v27QW2e7RleQOSj1/iPyPMKSXL43LlxePAXul8Ll+AFQMVlHq18Xpnt+6vQ6VodExigJpc9SXiC1t9GmLS7MUly5cuKBCnOfbZ9ln2WfZZ9Nn0WYIBXKXwvjfClrOXj9E4CVjMQsBZjTGFX2jzyhhBHJHP9vbc6T1l7imr7MoWEcaf8WI7egpGXLly5cuXL4XwvhfC3oPX8HpHtw3n23LgQda4h2ma6PYJon5bnTJsTUR4HseUUDn6B+GUY03frMDS238lIa4Jz+h5cLl8bly+Fy5fC4+0zYAACg/B6R7cftuXFTKfE0GowLCeJqtR/JQuRW4xT2455xW2N1SsCP3mMVb5/Mf2JAF9V68oRZNST8D1FmoNr+JcuXLl/hd8hmwABQfh9I9uP23LwXkVK5jkhoBWGSfjHxbTuMPb8AwF1Q9JcTsKK6xrGBt2PI4y7y8CQuHVdM+ZyyQ3A/3wX4rly4+Nw5ucAAFB+L0j24/bcvCuOVjs3NtL/FgJ4LyDFpNwdBzNvHfDW9ZWVhkWQ7OE9ji+1QRgTzv/Y9A3Uh8245KLWV7y5cuXLly+Ny+F3I5QKy/H6R7cftuXiybSm0cnf8AHzG0y6DpHEs22HwMaElApO35rly5cvwsUO8xHPm/L6R7cftuXicoqwzGXgDw8vJ8wvt+Pkx4YHokc0B+8ZPpHjY1wHvlBvL8lDUgHJvpKpeB0iDNrrxBVBXaai7EAKFG35vSPbj9ty8a53WJ7dJV1grvoflcteYWMvVvv/SWijSo8yWWA/8AEz9IqJc1DwMWjF5E3wUqWtCs7WE/7GZ5nSlB1XAhGrYvWy94aDebgvYwhgV21gSh9P5QIoq5VhNEcn+UcrzABckyhGsQzgygH6HpHtx+25fgQ+8lmHKlbE9x5O87fn0sFhtdHSYaTnYNLI0W8zjxrw+XAlqZVbkq6/o+ke3H7bl+HOg8PTZvB2PoCfs0RpqtRZCNx6SyENk8i4OoOhT55xVKqrirr+j6R7cftuX4mdLVq5b8kBVGrDO38gy5UuXLly5cvbxeXFZdZwGydglmUu0ebLbYL3GJqx576TL9T0j24/bcvxiiI0mSaQ0AdKv9h0Bei9GYuDX/ACmS9wPiKU27fym8+m0My9X8opRbvZ8cBJUWb0npF/2gYgjqMvhc3ckBLoSNH8JfDO9CWofzspa2FyD0iqIq5rn+x6R7cftuX661s7hMzRyfzglXOn8pdXR0Ee0uhHVX+76R7cftuX/seke3H7bl/wCx6R7cftuX/seke3H7bl/7HpHtx+25f+x6R7cEu4U3va/9j0724viwA0NH1/8AXRsigC1ZhKuDkuR5VxAQCOYx3cM6DyGfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmfWfmUgjJWp0WOGVeGpUqVKlSpUqVKlSpUqVKlSpUqVKlSpUqVKlSpUqVKlSpUqVKlSpUqVKlSpUqVKlEz3/8AhnQAzVoJsRgPsjRZvOk20Ah6eFgRZt6Rl3iKhNTC+sB3XU16Mti6vIOzj4HFoFmzkqDfEoilimudLAGR4qdzhmg2IDuxYJZ0B3qCXDIDbulQOiaMeZ4AZABargTOA9jvTCNuCnP/AKgPdDB5lzZ8yp15cRLAtSgIBVMkl7X+qwIzg4s6NZuxKBrhXB0s+rjG5biL8oELNjmLvPGXqpLHF+V4D1ikHYgewwejjLk0A2FOQ3AdExdV0A1YMneqmnLMWChTZ83nVy6pZUccPdUfM+oMe0MFVtbcnvj2LG4VgRdnNdG+ZrCciIWI6nBqEEvA0OPWAB0QCgqwxcbz4tEiwDHLKIwaqMxY6Y4y86+wzWh3Y6z7mpmBwA1UyQ9LvOrPQl3U0DeZcGBVhUObgpW8uwR5iMcXmcGmQSsT+bzEomGaPPe7hAQA01PoeS5VBV6OKQSFqlV9BJBmPO6tt8DMTbVFjk8n0eBIkkFiOcvwDaFKx6qFSUGgtyv9OsGaIzyXq0JTQIqXyDXNvlFijV2GdXm7+AQe0Oxh4bjMbmlbxGGOUVVux1tyYEeXZZWDQ5rWCtDQ6/74DCo4gbBItxbbW4lfQYAtCcyVmHOhM5uaTBd+5zMvYYPbj9NyIGLgd2xRXIFGaDb6QzxzmQU8xDBzjQWYMKy40tpryOVss+Hvcju4R3i9bRoGzNl1BLTAaMNOQg02oFAdPA0Aknh1Nn0gsCNUeCO5HSGgsTCiPvafbcv6bokntZTg+XVhQYq4sbFPY2PFhUio0mp8rlO5ZhxvoedsL0HUZ83v4reFA8MszuS0mio6GvSfOFQKts3C9cZIeQCd5QSgWOI+TXfgLo5K+I2BgUG3C2z7GWb5PKMlKwR0DFdmYvhpDTpqhi9S8Edte3BIcXJm5B5yoVmMKwVnWw84CAAoDQ8VK5VoNv8AeLkTRtGY9Up6nH23L+kkQzBqWMjUbI80JugINy/nxZCce3e9fMqAPXi8/PxgZnS9Yk0SX1q58z1aQJJY2jJx9q1yu+i4naEFANkjiTP1fjwUohJmJczhBlfJAgHScgjrGjyVLOp1MYMCKw7Zo2aVt6X/ADxgGaZwdE2medaGPU4+25f0ksTnK0ADvLA+bh5ywvNDLEHmPiNlXAGoZ+lznsLcdR3SvG2LKI10PNlJWGejCzzWDe1gHlwLrDYm9HLs5d5a04c5T6OZ3n2nPxCTyAB3Ie4iDp78r84mDkDeR8iWY3NtV9TDz8eYI9pQ+njCEWCvIp6JPU4+25f0xICBM9idcvKFyJbGbocrtOvhuXoFarEcGJIqDpocN217wwDiFic/CihCn7jCpvy1vzDNlmCnc2O77uPSvAsuvF5Enk9Ew/7CyjCbkEj9y8VJPhjq1gecNCcq6zajaKAcjRBP5EaZANuZs1Zv4mTGNrHTOnOXEc2kedkIIPybsTsUdp6nH23L+mj1Q2CM0FUODzI2TCUGL43bJ51DjTkAPciBQA1WExwvAV0GM1kn2PU/6TGu7rTNm5RvnKA4lBivk5kbzlHXRz5W6csEUO7Hg6EDNWoSBMluu6YEYMYRv5D/ADJY4vx96rV2hIBABgEtVVR5HEus1JTqtE3GJeCW5LKTqcCVg8BeW4g10S3P6CDqsZZzJXKTOVdBjNEELA1sgNCYXYArnDu4G0CgDAJRs2GUTI3cmYbQYgTS+TchRCLo7Opmd+DgTzEB3YcjIGwu+TyuJ8K9mIeZWLC9YwvoBgg0Bl5z1aONcHbOqILTNWgB9p/zM/5mLTy4AGZh+jUJx3LrLvWHmROJrOgOoPpLFivIx3VauX0jkuN0Y+sBp3KFm4ZvVZVWHnG5rwzsUED2ZeFzdYOhi9ZTtWvL7kmOENA3oqCsdYMM519lh49YUPRgGx5wOnU9AjjE6bM25KmI5VygoHmUsNlZBg7cTsBF1GQWd8WX9omBJxGbTBiheCvaKSWIFgD7KZbBhzlrplcDNIN95bahCa2l/ubqDdxCuK811eL7SExuhzO0wURwAjpiMr8BhgfPaEEhuvdYXDOgHpRD2Ydd0pZTvo8oAABQaEUz4iDpWMREwcfOVUYYWAtYF7XwKWrrFwLZYIGKKJYAoKM/3Kr8VcUvP8FXK/VuX478Vy//ADHmSlBTQcXOAIDHM2dyIZTEFrPNhD/G5LK4tdIKGIvs+ktcuEspFbi6QbW6F54m4DUJDrHpASj5QdGvQ8zexwzwhgFlVDN2TzhS5yiP00lu1c1A0p05UTfGWP8AeLyOjrHIUwBasg1XlH9epky8uApMMsxxDtaCVlJxN2NDr3yzjmIAyhgrVc7hMsxtNmRRi+ggpU9SHoL2LcQcYZQJqmHY5wdI7HJHUTRNSWEcCSLEIFGgFwmdE2C7AhO9xXiKhbpgoONLdXwd5aBFFQrEIFGgFwlNepwXmAhO9xmEJES6YKDjTpfB0KULsvWoYcVkEJEAAvnZMVG9Bd6GXunVsOWhuQnVugmDkkSXSVvNF0VljMYQgwiBRhnbfC5btFqRZkzmrkSg1xCHtRV5wLg4uuZHI2YS6YZIJCfCyLYVV0c+GVAxBbW2BlzfxJENUnpJcOCuawPZ1eB12EjgGzgK4q3hmJyerAKjPOHgkhlTPXanWCFqh7vNeCKsO1JV+Uwx76+xZCc6gAAAUBpwa4YPMnFTzRMOseWq5F2GPc16zPolXNZpqrrwu3XheFVnnERgO5hWQwyKnIDOaAOWPHIaPlmGN2zzjKkiklVyKWtDzmUDph2WHExyVRioqmqWtDMqvTrssOA+CoeQXHc7qPStm3umW9pjXPX18O4OAnVjiG4zKEhfpN9/VB5RBF+hfN61GK4MLR7HhQSO87aU3q4lSqU6ChW5adb4OgEKR1ILSqPQIKHza/0L2hshqbBbMTgep38iO/4wQnhjtWMu3JLID+CXJCm44RgTTZuIwyIF+voVH38CAPZQ7LVqxQBa7gjWpGmcoLTDvLBvIPfjpOHSMn0iNJod1EPTwYDoAZtivSPEkxedp/nbiyTdo7GPRe0IJc8uAixGK9dlc1M+6PgMuFXASxHTKI2Jvc1Fvncz2OKyzvyHzl6HGZ1JwMgYWtKnJqk62PhHQgGh5BLbgD60sfQQY3VL1vii9EnSrT4QzCri+YU+vgU5TeZvR7pmOeT0s/Soy3QqFZGT2A7fiQYX27BPRvuzGQR6UoXoxQwADNgVGDzjuQLGJzQ55iPBWYOJyTMYSgrpgj4lQqXDyLGuRHnlxly8ByMekLcNgBOpM2F1Dy5sod+2lNk0oAZ1jHSv5mmZsZkJLuy/LMGEQq2kHeOMaayG2jOlbLYrgRNZK09JiSO5Cm79EvBc4YEmSNjBoHA2jGYwzhN6wCw1Cq7oYkaMidYfRdi0pVjQZrAxY2SAEGqBVIQXFNXTGoCg7GROsT+9C2irGgZq4YQkcGtHCrOVIRtGFcJDR8VbFYewAXICiBsQVvTvnZCwK0CUMzHgDhXSTYHK0QHeKvENvF8IswCZdBIjQDsB1uIeKUp5XMYKW78HLp1GrR7NMZLB1VWidzvU5y9bwg/rUEFswDzlsaxq0nE9ILl9IEqO2U3vBsU6L3lAiSHEqvjz/EbQDjKHKgl1BsBpJv2Jehogu5Ql5axvaiwMNaCBc+kmzvqUKchUrhyj9T3buoSBeA8mOi6PJiKaYsHNM4iAUUiYJDYftHuafCavolfqVDvTMdIHblqPBvWuur1UTEsfsdDcoX1uO9fqHYDDYCW0GwtINjnWUM8tCB7TOwuQTuS6JigqPK5Q6V1lCCitp0c5YzQovYjtpIkLkyo5hVwL36JmW1t5RhlCV5BUMBFDI9mKnC+o0EZNKMhcmVGxVwswD0J0piKsQgsgF4GIRXINYcCV5QjTypkdY7J3fottowtq8Pa0aQAlTlJq5HSw9IejaRfaV2CYczXZCzK6cekCAyELA8JYRYsLAsKuteKnQgstzHM7RAVOVa7EI4SkrvMYvelNe2paFYGQvA04UdLGeuJiOGDkEUiXqAKMOINB/wDguU10lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2lm0s2ixenCzhhqiUwsOk3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdR3Ud1HdRt1xUNSrLjeeP3H/5W/8AzqwDWCPef2NGDYLgqK51bzwi4gI1pC6XhbvGJBckMaVRGXTkHEdpa1DOoexeGQWbRoxyJaIC0QsQ0qpePiiIN3pLL/FwZWsv7XBYFW2bimTwJAqm4gYCkwGb6u8vbKA4kL9g7kuBR5oYHsjKMQwVxdaZQ+Ui6Nq1xQ9ohNuOyWSkwiwQyavCNqiZFKHeOUW3ZphcZukxJQBo0+kUSHoUto1EqC5ApqNYqsXlCJyRV9cXapcihdHz0j5x2uCmY8kazyGBwAyrMKtRkGY+0WSaQ3Ml4lnswo0ggWzCUqnRnJMcIoM54rYrcipQOgI0HPCXQUXOjS5XhhvKfKG58B3UlprFOOO6HxX7CYuTUUael4MA+guoQGBg4N9oBADtULoNFMTqNYsNQDXOCSBnTjaG4RUsuDS1A5VGxOn1UwBs6RyFRVeVC7lpaoTGqkfUhwSZjEH2FwbQQBKFKekclTMqNFqHPKEUVmjWONvh2hCJ3VyBRlehtMRRwoY3V1mG2+Kl9q6KNYVCd7UVcWujuo0hqAm5AUp1jTLQhTFM4TLUsXlw6y1jI8EoDQVx/wCRnFMUtYGmxbLWKPQdNm0IzM7Rj1XpMu0QFDBeTkwNDkfJQ21gWmhUVYjnBTEiCGluboQgSqA51iqDBLKgl6Z6wqCUAUsFNsLmWYSK9DERhhSesjUJeCxdHYXL4VPd5QF7KATPA5c9iASCskcH9c0BhsCa0ggFujCXnXKAwCkLHtDRSUHENuXBystruXnlnMrEIQdLmJfMQdQgGR9P5TLcNI6sMYmKhqF8RgolLMK5VGamVQVdoiRFqCvWo5Um1J86mwyC9nBgnNqSvWppbBVVhUY5ysNTUM+8UNiyRPO6h45oZRyRgAlKFwO5MjuSo7TdxeQvyj9nbQC+0brogCwot1wgA14NHRcovV8wp2JjpWDE71Fag2pletR6UWFg7NR6qNqRXrUVvlgQecVFFgCPWph4uqC9ZhFADQdv1EkJBKoY1cBEoP8AcVfS5j1ZwG9DRjpKKrdHOFdZkgWpRpC52ZMEAQLYaIEF7pFIRw8+j/ZQQAQCpZTMof029TBJa1kkhZYOkbMezrKgdc5gBTYmi8DnUUC9RkQb1lIZPuovqgeGIY269mLpCNBuPFQGtlnODsYgfcqsCaMHOXoFQs1kj3iU9zStB8lkYy6sDBaI5SoDxFCWo4BhkVHQpuqrW75XtDIpYUrJaylmlhAkgdcIDPI9Yd2UqEW4OiD7zCtGS8VYWY5wskJNORcDXSIIEsV8h0hj2MTgd4CmMaHUZkCVqQCckZ1wLQBi4neKwUEWEFrbGUC4RMxdmSqjgZDxaGqJmXhCLXyGUu9RxMIDyVgIzXyjiykCHJNdn9L7LlwRcTCsyL5maMgBoYZMVykPOpnvrAFkHzq9ahIrQFOVYTlyQZZfWF54JZjTkkwSa0VZJhWxMIg487BeYz77kmQqWV5Biarn2glc1ZBpp2npEFjVBWbdHPOGobItyrGJtKHyPm4RFLG87IiKfMaqeTDZl0WZzFtd1eCn33NPUZ+j5TGITAra0XbGY/qYoXUUBQT6+yCo+o1FNUGOBisMunuxgSlgAFq6RvAw4zJhlpMAtLspbUvWCII2Opwxd5WOQZU1/s1UI6hou+8xHqEyxXmbS2BMoG2UESKa1xNafaCwlc7Z6i9K/Sa9OsoTQ5zAdqGk0wWrl2zS9r1USlVUG03lGlTHLAWy4rUw7SGpyTkkEbIaAyoYKHS4/VRuOhgZDQgYvUAwopu5SGNgAbDkCGfKP0ai2HA3kastuoKAI4HaVzLRZgVdXUeSI2g5bTvKXLQlRWK8usNFXXbuGo6kQO66qzo4JOsw9iGrzV1WXtFyabDPK6ltIijiOTjycSXiJlCs7bzlam831zUYto2O1Bi1bvGexSnBrA5wgAFNQMBq6uWfcqAYShjrA8tMSC6McpjOzIBo45RdrpjaLvBe2sG1lpYCsR1jDhiETAzqolsZBGoxcLjDPEkwDVl0iQSgksYmLhcqFJJwiluOk0BpqeaolS1MlhTVOWBDYFAwht1xh4OqyURnVWsHyscwtyct46ocRTNa8+kPZjwuOZakoNqmIJba/wD4Rv/Z';