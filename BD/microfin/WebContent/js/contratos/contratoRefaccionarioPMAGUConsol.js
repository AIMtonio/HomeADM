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
var contratoAdmonGenUnico = 1;

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
var escriturasPub = [];

var paramUEAU = [];

function generarContratoRefaccionarioPM(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
						RFCInst, direccionInst, telefonoInst, calcInteres, fechaEmision) {
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
		escriturasPub = contrato[14];
	}});

	edoCtaParamsServicio.consulta(1,{ async: false, callback:function (EdoCta){
		if(EdoCta!=null){						
			paramUEAU = EdoCta
		}
	}});

	// Se evalua que tipo de persona Moral es (Admin. General ??nico | Consejo de Admon.).
	if (consejoAdmon != null){
		if(consejoAdmon[0].cargoID == contratoAdmonGenUnico){
			generarContratoRefaccionarioPMAGU(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
												RFCInst, direccionInst, telefonoInst, calcInteres, fechaEmision);
		}else {
			if(consejoAdmon[0] == undefined || consejoAdmon[1] == undefined || consejoAdmon[2] == undefined || consejoAdmon[3] == undefined){
				mensajeSis("El registro del consejo de administraci??n est?? incompleto.");
			}else{
				generarContratoRefaccionarioPMCA(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
													RFCInst, direccionInst, telefonoInst, calcInteres, fechaEmision);
			}
		}
	}else{
		mensajeSis("Hace falta registrar a los relacionados a la persona moral.");
	}
}


function generarContratoRefaccionarioPMAGU(creditoID, productoCreditoID,  monedaID, montoTotal, razonSocialInst,
						RFCInst, direccionInst, telefonoInst, calcInteres, fechaEmision) { 
	
	var documento = {
		pageMargins: [45,60,45,65],
		footer: function(currentPage, pageCount) {
			return [
				{ text: 'P??gina ' + currentPage.toString() + ' de ' + pageCount, alignment: 'center' }
			  ]
			 },
		header: {
		columns: [
			{ text: ['CONTRATO DE ADHESI??N CR??DITO ',generalesAgro.nombreProd],
				alignment: 'left',
				margin: [25, 25, -35, 0]
			},
			{ stack: [
			'No. de Cr??dito ' + generales.creditoID,
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
								{ text: 'S??NTESIS DEL CONTRATO DE ADHESI??N EN CUADRO INFORMATIVO\n', bold: true },
								'El siguiente cuadro informativo forma parte integral del contrato de adhesi??n.'
					],
					style: 'header'
					}
				],
				margin: [20, 0, 20, 0]
			},

			// ************** Car??tula del Contrato **************
			{ table: {
				widths: [175, '*'],
				body: [
					[
						{ text: 'CAT a la fecha de contrataci??n, a tasa fija y/o tasa variable, para fines informativos y de comparaci??n exclusivamente:', bold: true },
						{ text: generales.CAT, bold: true },
					],				
					[
						{ text:'Monto de la operaci??n:', bold: true },
						{ text:generales.montoTotal, bold: true },
					],
					[
						{ text:'Plazo:', bold: true },
						generales.plazo,
					],
					[
						{ text:'Tasa de inter??s anual fija ordinaria:', bold: true },
						{ text:generales.tasaOrdinaria, bold: true },
					],
					[
						{ text:'Tasa de inter??s moratoria Vencida:', bold: true },
						{ text: 'Tasa de Inter??s Ordinaria por DOS m??s I.V.A.', bold: true },
					],
					[
						{ text:'Comisi??n por administraci??n:', bold: true },
						{ text: [generales.comisionAdmon, ' del cr??dito total = ', generales.montoComAdm] },
					],
					[
						{ text:'Fecha de corte:', bold: true },
						'D??a ??ltimo de cada mes',
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
							generales.vigenciaLetra + ' meses a partir de la contrataci??n.'
							
						  ]
						}
					],
					[
						{ text:'Garant??a FEGA:', bold: true },
						{ text:[garantiaFira(catTipoConsultaGarFIRA.refaccionarioFEGA, garantiasFira),' m??s I.V.A. por el monto del cr??dito.']},
					],
					[
						{text:'Beneficiario preferente:',bold: true },
						razonSocialInst,
					],
					[
						{text:'Datos de la unidad Especializada de atenci??n a usuarios:',bold: true },
						generales.datosUEAU,
					]
				]
				},				
				margin: [0, 20, 0, 0]
			},

			// **************** Tabla de garant??as ***************
			{
				table: {
					widths: ['*'],
					body: [
						[
							{ stack: [
								{ text: 'GARANT??AS: Para garantizar el pago de este cr??dito, "EL GARANTE PRENDARIO(S),  GARANTE(S)  HIPOTECARIO(S)  O  USUFRUCTUARIO(S)" deja en garant??a el bien que se describe a continuaci??n:', bold: true}
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

			// ************** Tabla de amortizaci??n **************
			{ text: '\n\n'},
			{ text: 'TABLA DE AMORTIZACI??N\n',
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
					generales.nomRepresentanteLeg,
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
					generales.nombreCliente+aliasCliente(generales.aliasCliente),
					{ text: 'REPRESENTADA EN ESTE ACTO POR EL C.', bold: false },
					'\n',
					'\n',
					'___________________________________',			
					consejoAdmon[0].nombreCompleto,
					{ text:consejoAdmon[0].nombreCargo, bold: false },
					{ text:generales.direccionCliente, bold: false }
				],
				bold: true,
				style: 'header',
				alignment: 'center',
				pageBreak: 'after'
			},

			// *************** Generales contrato ****************
			{
				text: [
					'CONTRATO DE APERTURA DE CR??DITO AGROPECUARIO ',
					{ text: 'REFACCIONARIO, ', bold: true },
					'CON GARANT??A PRENDAR??A, USUFRUCTUARIA, HIPOTECARIA Y/O GARANT??A LIQUIDA QUE CELEBRAN POR UNA PARTE LA EMPRESA DENOMINADA "',
					{ text: razonSocialInst, bold: true },
					'" COMO ACREDITANTE, A QUIEN EN LO SUCESIVO Y PARA EFECTOS DEL PRESENTE CONTRATO SE DENOMINARA ',
					{ text: ' "LA ACREDITANTE"', bold: true },
					', REPRESENTADO EN ESTE ACTO POR EL C. ',
					{ text: generales.nomRepresentanteLeg, bold: true },
					', EN SU CAR??CTER DE ',
					'APODERADO LEGAL;',
					' Y POR LA OTRA PARTE LA PERSONA MORAL: ',
					{ text: generales.nombreCliente, bold: true },' ',
					
					'REPRESENTADO EN ESTE ACTO POR EL C. ',
					{ text: consejoAdmon[0].nombreCompleto, bold: true },
					aliasCliente(consejoAdmon[0].alias).toUpperCase().substring(1),
					' EN SU CAR??CTER DE ',
					{ text: consejoAdmon[0].nombreCargo, bold: true },

					', COMO ACREDITADO(S) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINAR?? CONJUNTA E INDISTINTAMENTE COMO ',
					{ text: '"EL ACREDITADO"', bold: true },
					', AS?? MISMO COMPARECE(N) EL(LOS) SE??OR(ES):',
					generalGarantes.cadenaGarantes,
					' COMO GARANTE(S) PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) Y/O GARANTE(S) USUFRUCTUARIO(S) A QUIEN(ES) EN LO SUCESIVO SE LE(S) DENOMINAR?? CONJUNTA E INDISTINTAMENTE COMO ',
					{ text: ' "EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)"', bold: true },
					', AS?? MISMO COMPARECE (N) EL (LOS) SE??OR (ES): ',
					generalAvales.cadenaAvales,
					' COMO EL (LOS) AVAL (ES) U OBLIGADO SOLIDARIO A QUIEN (ES) EN LO SUCESIVO SE LE (S) DENOMINAR?? CONJUNTA E INDISTINTAMENTE COMO ',
					{text: '"EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true},
					', DE CONFORMIDAD CON LAS SIGUIENTES DECLARACIONES Y CL??USULAS.'
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
						{ text: [' Bajo protesta de decir verdad declara "CONSOL NEGOCIOS SOCIEDAD AN??NIMA DE CAPITAL VARIABLE SOCIEDAD FINANCIERA DE OBJETO M??LTIPLE ENTIDAD NO REGULADA" (SOFOM ENR) por conducto de su representante legal:'] },
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								'Que es una Sociedad An??nima de Capital Variable legalmente constituida conforme a las leyes de la Rep??blica Mexicana, seg??n consta en Escritura P??blica n??mero 13,424 de fecha 05 de agosto de 2004 pasada ante la fe del Notario P??blico n??mero 3 tres de la ciudad de Tlajomulco de Z????iga, Jalisco, Licenciado Edmundo M??rquez Hern??ndez. Inscrita en el Registro P??blico de la Propiedad y de Comercio del Estado de Jalisco con el folio mercantil Electr??nico No. 23674*1, el d??a 17 de agosto de 2-e04.',

								'Que con fecha 05 (Cinco) del mes de Marzo del 2007 se cambi?? la denominaci??n social de "FIRAGRO SA de CV" a "CONSOL NEGOCIOS SA de CV SOFOM ENR", seg??n consta en la Escritura P??blica n??mero 16,356 (Diecis??is Mil Trescientos Cincuenta y Seis) otorgada bajo la fe del notario p??blico n??mero 3 (tres) Lic. Edmundo M??rquez Hern??ndez, en legal ejercicio en la ciudad de Tlajomulco de Z????iga, Jalisco e inscrita en el Registro P??blico de la Propiedad y de Comercio del estado de Jalisco con fecha 29 de marzo del 2007 con el folio mercantil Electr??nico No. 23674*1',

								{ text: ['Las facultades con las que act??a no le han sido revocadas ni restringidas, por lo que comparece en pleno ejercicio de facultades delegadas, seg??n consta en la Escritura P??blica n??mero 16,473 (Diecis??is Mil Cuatrocientos Setenta y tres) que contiene la aclaraci??n de la sociedad denominada CONSOL NEGOCIOS S.A. DE C.V. SOFOM ENR, de fecha 02 (Dos) de mayo del 2007 otorgada bajo la fe del notario p??blico n??mero 3 (tres) Lic. Edmundo M??rquez Hern??ndez, en legal ejercicio en la ciudad de Tlajomulco de Z????iga, Jalisco, e inscrita en el Registro P??blico de la Propiedad y de Comercio del Estado de Jalisco con fecha 25 de junio del 2007.']},
																
								{ text: ['La personalidad con la que se act??a se acredita mediante la Escritura P??blica n??mero ' +  generales.numEscPub + ' de fecha ' + generales.fechaEscPub + ' otorgada ante la Fe del Notario P??blico N??mero ' + generales.numNotariaPub + ' de la Ciudad de '+ generales.nomMunicipioEscPub + ', ' + generales.nomEstadoEscPub + ', Lic. '+ generales.nombreNotario +' inscrita en el Registro P??blico de la Propiedad y de Comercio con el Folio Mercantil Electr??nico No. ' + generales.folioMercantil + ' en el cual se otorga al  ', { text: 'C. ' + generales.nomRepresentanteLeg, bold: true },' poder Judicial para Pleitos y Cobranzas y para Suscripci??n de T??tulos y Operaciones de Cr??dito en los t??rminos del Art??culo 9?? noveno de la Ley General de T??tulos y Operaciones de Cr??dito.'] },

								'Que para su constituci??n y operaci??n como SOCIEDAD FINANCIERA DE OBJETO M??LTIPLE ENTIDAD NO REGULADA, no requieren de autorizaci??n de la Secretar??a de Hacienda y Cr??dito P??blico.',
								
								'Que tiene su domicilio en calle Ju??rez Norte n??mero 06 Colonia Centro, C.P. 45640, en Tlajomulco de Z????iga, Jalisco.',

								'Que la sociedad an??nima que representa tiene por objeto social entre otros, el arrendamiento y factoraje financiero, as?? como el otorgar financiamiento a las personas f??sicas o morales cuya actividad sea la producci??n, acopio y distribuci??n de bienes y servicios de o para los sectores agropecuario, silv??cola y pesquero; as?? como de la agroindustria y de otras actividades conexas o afines o que se desarrollen en el medio rural. Realizar actividades y operaciones de cr??dito y servicios, sin que dentro de estas actividades y de sus estados financieros se incluya la intermediaci??n de recursos provenientes de captaci??n directa del p??blico o cr??ditos de personas f??sicas o morales no reguladas por las autoridades financieras. Para tal efecto tiene un contrato de apertura de l??nea de cr??dito con el banco de M??xico en su car??cter de fiduciario del fideicomiso denominado Fondo Especial para Financiamientos Agropecuarios (FEFA) o (FIRA). ',

								'Para la realizaci??n de las operaciones se??aladas, no est?? sujeta a la supervisi??n y vigilancia de la Comisi??n Nacional Bancaria y de Valores.',
								
								'Que tiene autorizaci??n del BANCO DE M??XICO COMO FIDUCIARIO DEL FIDEICOMISO DENOMINADO FONDO ESPECIAL PARA FINANCIAMIENTOS AGROPECUARIOS, para operar como SOFOM ENR.',

								'Que est?? de acuerdo en la celebraci??n del presente contrato, por lo que comparece por cuenta de su representada.\n\n\n'
							]
						},
					],
					[
						{ text: [ 'Bajo protesta de conducirse con verdad Declara ', { text: '"EL ACREDITADO"', bold: true}, ':']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
									{ text: ['Que es una ',
										escriturasPub.tipoSociedad,
										' constituida mediante escritura n??mero ',
										escriturasPub.escPublicPM,
										' de fecha ',
										escriturasPub.fechaEscPM,
										' pasada ante la fe del notario p??blico n??mero ',
										escriturasPub.escPublicPM,
										', ',
										escriturasPub.nombreNotarioPM,
										' de la municipalidad de ',
										escriturasPub.municipioNotariaPM,
										', ',
										escriturasPub.estadoNotariaPM,
										', la cual se encuentra inscrita en el Registro P??blico de la Propiedad y de Comercio con sede en, ',
										escriturasPub.direccionNotariaPM,
										' con el folio mercantil ',
										escriturasPub.folioMercantilPM,'.'
									]},
									{ text: [
										'Las facultades con las que act??a no le han sido revocadas ni restringidas, por lo que comparece en pleno ejercicio de facultades delegadas, seg??n consta en la Escritura P??blica n??mero ',
										escriturasPub.numEscPub,
										' que contiene la protocolizaci??n del acta de asamblea general extraordinaria donde se nombra al consejo de Administraci??n Presidente_, Secretario_, Tesorero_ y como ',
										escriturasPub.cargoApoLegal,
										' a ',
										escriturasPub.nomApoderadoLegal,
										' con poder para pleitos y cobranza; para actos de administraci??n  y de dominio; poder para otorgar y suscribir t??tulos y operaciones de cr??dito; de fecha ',
										escriturasPub.fechaEscPub,
										' pasada ante la fe del Notario P??blico n??mero ',
										escriturasPub.numNotariaPub,
										' Lic. ',
										escriturasPub.nombreNotario,
										' de ',
										escriturasPub.nomEstadoEscPub,
										' instrumento _, volumen _',
										escriturasPub.folioMercantil,'.'
									]},
									{ text: [
										'Que tiene su domicilio en la Calle ',
										generales.direccionCliente
									]},
									{ text: [
										'Que la ',
										escriturasPub.tipoSociedad,
										'tiene por objeto social '
									]},
									{ text: [
										'Que cuenta con cedula de identificaci??n fiscal ', 
										RFCInst,
										' de fecha de inicio de operaciones ',
										generales.fechaIniCredito
									]},
									{ text: [
										'Que est?? de acuerdo en la celebraci??n del presente contrato, por lo que comparece por cuenta de su representada. '
									]},
									{ text: [
										'Que se encuentra(n) al corriente en el pago de sus impuestos y obligaciones de car??cter fiscal que se generan por los bienes que integran su patrimonio y por sus operaciones sin acreditarlo.'
									]},
									{ text: [
										'Que a la fecha no existe ninguna acci??n, juicio o procedimiento alguno de cualquier naturaleza pendiente o en tr??mite ante cualquier tribunal, dependencia gubernamental o ??rbitro, que pudiera afectar en forma alguna su condici??n financiera o sus operaciones.'
									]},
									{ text: [
										'Que para el fomento de sus actividades ha solicitado a "LA ACREDITANTE" el Cr??dito materia del presente contrato para destinarlo a los fines  previstos en el mismo. '
									]},
									{ text: [
										'Toda la documentaci??n e informaci??n que ha entregado a la ???LA ACREDITANTE??? para el an??lisis y estudio del otorgamiento del presente contrato es correcta y verdadera. '
									]}


							]
						}
					],
					[
						{ text: [ 'Declara(n)  ', { text: '"EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)" Y "EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true}, ' que:']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								'Es (son) persona(s) f??sica(s), mayor(es) de edad, persona moral legalmente constituida, que cuenta(n) con la debida capacidad y facultades legales necesarias para obligarse en t??rminos del presente contrato.',

								{text: ['Que es su inter??s constituirse en el presente instrumento en cuanto ',{ text: '"EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)" Y "EL(LOS) AVAL(ES) U OBLIGADO SOLIDARIO"', bold: true},' de la "PARTE ACREDITADA" adquiriendo los derechos y obligaciones que del mismo se deriva.\n\n\n']}
							]
						}
					],
					[
						{ text: [ { text: '"DECLARACIONES COMUNES QUE DERIVAN DE LA LEY PARA LA TRANSPARENCIA Y ORDENAMIENTO DE LOS SERVICIOS FINANCIEROS."', bold: true}, '\nEn cumplimiento a la citada ley y sus reglamentos, las partes declaran:']},
						{
							type: 'lower-alpha',
							separator: ')',
							ol: [
								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' explic?? a ',{ text: '"EL ACREDITADO"', bold: true},' los t??rminos y condiciones definitivas de las cl??usulas con contenido financiero, as?? como las comisiones aplicables, y dem??s penas convencionales contenidas en este contrato, manifestando el acreditado que dicha explicaci??n ha sido a su entera satisfacci??n.']},

								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' y el ',{ text: '"EL ACREDITADO"', bold: true},' acordaron libremente modificar los t??rminos y condiciones de la oferta crediticia ajust??ndolo a satisfacci??n mutua de las partes.']},

								{text: ['Que ',{ text: '"LA ACREDITANTE"', bold: true},' dio a conocer al ',{ text: '"EL ACREDITADO"', bold: true},' el c??lculo del costo Anual Total ',{ text: '"CAT"', bold: true},'del cr??dito correspondiente al momento de la firma de este instrumento.']}
							]
						}
					]
				]
			},

			// ************ Clausulado del contrato **************
			'\nExpuesto lo anterior, los comparecientes celebran el presente contrato de conformidad con las siguientes:\n\n',
			{ // Clausulas
				text: 'C L ?? U S U L A S:',
				bold: true,
				style: 'header'
			},
			{
				text:'\n\n'
			},
			{ // Clausula Primera
				text: [
					{ text: 'PRIMERA.- DEFINICIONES; DISCREPANCIA DE DEFINICIONES; ANEXOS.\n', bold: true },
					
					{text: [,{ text: '"Inciso A. "', bold: true},' Definiciones. Los t??rminos definidos a continuaci??n tendr??n en el presente Contrato los significados atribuidos a dichos t??rminos en este Inciso:\n']},

					'"Causas de Vencimiento Anticipado": Significa cualquiera de los supuestos previstos con tal car??cter en este Contrato.\n',

					'"CONDUSEF": Significa la Comisi??n Nacional para la Defensa de los Usuarios de Servicios Financieros.\n',

					'"Contrato": significa el presente instrumento, sus anexos y cualquier convenio que lo modifique o adicione.\n',

					'"Costo Anual Total" o "CAT": Significa el costo de financiamiento expresado en t??rminos porcentuales anuales que, para fines informativos y de comparaci??n exclusivamente, incorpora la totalidad de los costos y gastos inherentes a los cr??ditos que otorgan las instituciones de cr??dito, el cual deber?? ser calculado de acuerdo con los componentes y metodolog??a referidos en el numeral M.26.2 de la Circular 2019 de Banco de M??xico y previstos en la Circular 15/2007 de Banco de M??xico.\n',

					{text: ['"Cr??dito": Es la cantidad de dinero u otro medio de pago  que ',{ text: '"LA ACREDITANTE"', bold: true},' otorga a ',{ text: '"EL ACREDITADO"', bold: true},' conforme a este Contrato, hasta por el importe que se establece en la Cl??usula Segunda de este Contrato.\n']},

					'"D??a H??bil": Significa cualquier d??a en que deban estar abiertas al p??blico las Instituciones de Cr??dito en los Estados Unidos Mexicanos para realizar operaciones, de acuerdo al calendario publicado por la Comisi??n Nacional Bancaria y de Valores, as?? como aquellos d??as del a??o en que no se requiera que dichas Instituciones de Cr??dito cierren sus puertas al p??blico y suspendan sus operaciones de acuerdo con las disposiciones que al efecto dicte la Comisi??n Nacional Bancaria y las dem??s autoridades competentes.\n',

					{text: ['"Estado de Cuenta": Significa el documento elaborado por  ',{ text: '"LA ACREDITANTE"', bold: true},' en el cual constan los datos sobre identificaci??n del contrato en donde conste ',{ text: '"EL CR??DITO"', bold: true},' cotorgado, el monto de este vencido no pagado, los saldos insolutos pendientes por vencer; la tasa de inter??s de',{ text: '"EL CR??DITO"', bold: true},'aplicables a cada periodo de pago; los intereses moratorios generados, el importe de accesorios generados y los pagos realizados por', { text: '"EL ACREDITADO"\n', bold: true}]},

					'"Impuestos": Significa cualesquiera tributos, contribuciones, cargas, deducciones o retenciones de cualquier naturaleza que se impongan o se graven en cualquier tiempo por cualquier autoridad, incluyendo cualquier otra responsabilidad fiscal junto con intereses, sanciones, multas u otros conceptos derivados de los mismos.\n',

					'"Pesos": Significa la moneda de curso legal de los Estados Unidos Mexicanos.\n',

					'"Seguro de vida": es el seguro que el acreditado est?? obligado a contratar en t??rminos del presente contrato, y que ampara el pago del adeudo del cr??dito hasta la suma asegurada contratada, en caso de muerte natural o por accidente.\n',

					'"Seguro de da??os": Es un seguro amplio que el acreditado y/o el garante hipotecario, seg??n sea el caso, est??(n) obligado(s) a contratar en t??rminos del presente contrato, contra los da??os que pueda sufrir el(los) bien(es) sobre el(los) cual(es) se constituye(n) la hipoteca o prenda y que por su naturaleza sean asegurables.\n',

					'"Tasa de Inter??s Interbancaria de Equilibrio (T.I.I.E.)": por T.I.I.E. se entender?? la tasa que determine el Banco de M??xico para operaciones denominadas en Moneda Nacional, a plazo de 28 (Veintiocho) d??as, la T.I.I.E. que servir?? de base para el c??lculo de los intereses ser?? la ??ltima publicada previo al inicio del periodo en que se devenguen los intereses respectivos. La cifra promedio ponderado que en cada mes se utilizar?? estar?? dada en tanto por ciento con cuatro cifras decimales, tal y como lo da a conocer Banco de M??xico, sin ning??n redondeo.\n',

					{text: ['"Unidad Especializada": Significa la unidad especializada de atenci??n a usuarios de   ',{ text: '"LA ACREDITANTE"', bold: true},' , cuyo objeto es atender cualquier queja o reclamaci??n de los clientes, la cual cuenta con el siguiente tel??fono lada sin costo ', paramUEAU.telefonoUEAU,', ', paramUEAU.otrasCiuUEAU,', Fax-33-379-802-37 y su correo electr??nico de atenci??n es', paramUEAU.correoUEAU,'. Dicha Unidad Especializada cuenta con personal en los Estados de la Rep??blica Mexicana en los que CONSOL cuenta con Sucursales, cuyos datos podr??n ser obtenidos por los clientes en cualquier sucursal de ',{ text: '"LA ACREDITANTE".\n\n', bold: true}]},

					{text: [,{ text: '"Inciso B. "', bold: true},' Discrepancia en Definiciones. En caso de cualquier discrepancia entre las definiciones contenidas en el Inciso A. de esta Cl??usula Primera y cualquier otra estipulaci??n del presente Contrato, prevalecer?? esta ??ltima, y en caso de cualquier discrepancia entre el  presente Contrato y los Anexos del presente, prevalecer?? este Contrato.\n']},

					{text: [,{ text: '"Inciso C. "', bold: true},' Anexos. Los siguientes Anexos se adjuntan e incorporan al presente Contrato por referencia:  ',{ text: 'Anexo "1".\n', bold: true}]},
				
				]
			},
			{text:'\n\n'},
			{ // Clausula Segunda
				text: [
					{ text: 'SEGUNDA.- OTORGAMIENTO DE "EL CR??DITO".-', bold: true },
					' Por este acto ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' establece en favor de ',
					{ text: '"EL ACREDITADO"', bold: true },
					' un Cr??dito ',
					{ text: '"REFACCIONARIO"', bold: true },
					' hasta por ',
					generales.montoTotal, '.',
					' Este monto se denominar?? dentro del presente contrato como ',
					{ text: '"EL CR??DITO".\n\n', bold: true },

					'Dentro del monto de ',
					{ text: '"EL CR??DITO"', bold: true },
					'no incluyen las comisiones previstas en este contrato, los intereses m??s I.V.A., y gastos que deba de cubrir la "EL ACREDITADO", con motivo de las obligaciones contra??das y que se estipulan en el presente instrumento.\n',
					'Para efectos administrativos el presente cr??dito quedar?? identificado con el n??mero de cr??dito establecido en el margen superior derecho de cada hoja de ??ste contrato de adhesi??n.\n\n',
					'El monto del pr??stamo a que se refiere el p??rrafo anterior representa el ',
					(parseFloat(generalesAgro.recursoPrestConInv).toFixed(2)*100/parseFloat(generalesAgro.montoTotConcepInv).toFixed(2)).toFixed(2),
					'% de los recursos que requiere ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'para desarrollar el Proyecto, oblig??ndose ',
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
					{ text: 'TERCERA.- DESTINO DE "EL CR??DITO".- "EL ACREDITADO"', bold: true },
					', se obliga a invertir el monto del Cr??dito otorgado, as?? como las sumas complementarias que aporte con sus propios recursos, a los fines se??alados en el concepto de Inversi??n que se agrega al presente contrato como Tabla "A". En caso de no hacerlo e independientemente de ser causa de rescisi??n del presente contrato, ',
					{ text: '"EL ACREDITADO"', bold: true },
					' pagar?? como pena convencional a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					', una cantidad equivalente a 2 dos veces la tasa de Inter??s ordinaria m??s I.V.A. pactada en el punto 1 de la cl??usula Quinta del presente contrato.\n\n'
				]
			},
			{ // Tabla A - Proyecto de inversi??n.
				text: [
					{ text: 'TABLA ???A??? PROYECTO DE INVERSI??N', style: 'header', bold: true}
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
					{ text: 'CUARTA.- DISPOSICI??N DEL CR??DITO.- "EL ACREDITADO"', bold: true },
					'dispondr?? del importe del Cr??dito concedido en ??ste Contrato de Adhesi??n de acuerdo al calendario de ministraciones que se agrega al presente contrato como Tabla "B", y a trav??s de la suscripci??n y entrega de un pagar?? m??ltiple o de pagar??s seriados a favor de ',
					{ text: '"LA ACREDITANTE"', bold: true },
					' , cuyo plazo no exceder?? en ning??n caso al de la duraci??n del presente contrato, mismos que contendr??n las anotaciones a que se refiere el Art??culo 325 trescientos veinticinco de la Ley General de T??tulos y Operaciones de Cr??dito.'
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
					'reconoce y acepta que esta disposici??n se sujeta a los derechos y obligaciones establecidos en el Contrato de Cr??dito en Escritura P??blica N??mero ________, de Fecha __ de ________ del __ pasada ante la fe del Licenciado ________, Notario P??blico N??mero _____ (___), con ejercicio en ________ municipio de ________, del estado de ________. As?? tambi??n ',
					{ text: '"EL ACREDITADO", "EL GARANTE PRENDARIO (S), GARANTE (S) HIPOTECARIO (S) O USUFRUCTUARIO" ', bold: true },
					'acepta(n) que la(s) garant??a(s) descrita(as) en la Cl??usula D??cima Primera de ??ste contrato no podr?? ser liberada de todo gravamen en tanto no se liquide ??sta operaci??n de Cr??dito al amparo de ??ste Contrato, tal y como lo establece el contrato de cr??dito en Escritura P??blica ya mencionada al inicio del p??rrafo; por lo que reconoce la ampliaci??n del plazo de dicha escritura hasta la total liquidaci??n de ??ste CONTRATO DE ADHESI??N DE CR??DITO ',generalesAgro.nombreProd,'.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'faculta de manera expresa a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					'para ceder, descontar, endosar y/o negociar en cualquier forma el presente contrato, pagar??s, garant??as prendarias e hipotecarias, garant??a natural y toda aquella documentaci??n que forme parte del contrato materia del presente cr??dito, aun antes de su vencimiento, lo anterior ya sea a persona F??sica o Moral, P??blica o Privada.\n\n',

					{ text: '"LA ACREDITANTE"', bold: true },
					'por su parte se obliga a vigilar la inversi??n de fondos y a cuidar y conservar las garant??as otorgadas en los t??rminos del Art??culo 327 trescientos veintisiete de la Ley General de T??tulos y Operaciones de Cr??dito, para lo cual ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'le deber?? proporcionar todas las facilidades necesarias para dicho fin.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a entregar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en el domicilio se??alado en el punto ',
					{ text: 'I ', bold: true },
					'inciso ',
					{ text: 'f ', bold: true },
					'de Declaraciones del presente contrato, dentro de un plazo que no exceda de 30 treinta d??as naturales siguientes a la fecha en que haya recibido el monto del presente cr??dito, todas las facturas o documentos que justifiquen fehacientemente los gastos efectuados as?? como la correcta inversi??n del Cr??dito. Los gastos originados por el env??o de dichos documentos ser??n a cargo de ',
					{ text: '"EL ACREDITADO".', bold: true },

				]
			},
			{text:'\n\n'},
			{ // Clausula Quinta
				text: [
					{ text: 'QUINTA.- CONCEPTOS DE COBRO Y MONTOS.-\n', bold: true },
					{ text: '1.- TASA DE INTER??S.-', bold: true },
					'Los intereses se calculan dividiendo la Tasa de Inter??s Ordinaria aplicable entre 360, multiplicando el resultado as?? obtenido por el n??mero de d??as naturales del mes que corresponda, la tasa que se obtenga conforme a lo anterior, se multiplicar?? por el saldo del cr??dito; el c??lculo de intereses ordinarios m??s I.V.A. se efectuar?? mediante el esquema de ???Financiamiento Adicional???, descrito en la cl??usula Decima del presente contrato. Las fechas para el c??lculo de intereses corresponden a los periodos que conforman la Tabla B MINISTRACIONES de la Cl??usula Cuarta y la Tabla C AMORTIZACIONES que se encuentra ubicada en la Cl??usula Sexta del presente Contrato.\n',
					'En caso de que el Banco de M??xico, modifique la Tasa de Inter??s se??alada, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a pagar la nueva tasa correspondiente a partir de la fecha en que entre en vigor, tomando como base el instrumento que decrete el Banco de M??xico para estas operaciones de cr??dito a la tasa que resulte.\n',

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
					{text: [{ text: 'PARA CR??DITOS DE HABILITACI??N O AV??O, ', bold: true},'Intereses ordinarios sobre saldo insoluto a una tasa de 0.0%  (Cero Punto Cero) Por Ciento Anual m??s I.V.A.']},
					{text: [{ text: 'PARA CR??DITOS REFACCIONARIOS, ', bold: true},'Intereses ordinarios sobre saldo insoluto a una tasa fija de',{ text: generales.tasaOrdinaria, bold: true},' ',{ text: 'Por Ciento Anual m??s I.V.A.', bold: true},' de acuerdo a lo previsto en los Art??culos 9 de la Ley para la Transparencia y Ordenamiento de los Servicios Financieros y 5, fracci??n V, inciso b) de las Disposiciones de Car??cter General en Materia de Transparencia aplicables Sociedades Financieras de Objeto M??ltiple, Entidades no Reguladas.\n\n']}
				]
			},
			{
				text: [
					{ text: '2.- INTERESES MORATORIOS .- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no pague puntualmente alguna cantidad que debe cubrir a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'conforme al presente contrato, dicha cantidad devengar?? intereses moratorios desde la fecha de su vencimiento hasta que se pague totalmente, intereses que se devengar??n diariamente, que se pagar??n a la vista y ',
					{ text: 'conforme a la tasa de inter??s ordinaria multiplicada por DOS m??s I.V.A. ', bold: true },
					'y causar?? efecto: '
				],
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					'Sobre cualesquiera de los saldos vencidos no pagados oportunamente.',
					'Sobre el saldo total adeudado si ??ste se diere por vencido anticipadamente y.',
					{text: ['Sobre el importe de otras obligaciones patrimoniales a cargo de ', { text: '"EL ACREDITADO"', bold: true},' que no sean por capital e intereses, si no fueren cumplidas en los t??rminos pactados en este contrato.']},
				]
			},
			{
				text: [
					'Los intereses moratorios en caso de que se causen, junto con los impuestos que generen de acuerdo con las leyes respectivas, deber??n pagarse al momento en que se liquide el adeudo.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'manifiesta expresamente su conformidad en el sentido de sujetarse a cualquier otro cambio que determine F.I.R.A. en relaci??n con los porcentajes de descuento y  tasas aplicables a dichos porcentajes.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a que todas las cantidades que deba de pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'tanto de capital como de intereses m??s I.V.A., los cubrir?? en los d??as se??alados, en horas h??biles bancarias y sin necesidad de requerimiento o cobro previo en el domicilio que m??s adelante se le indica.\n\n'
				],
			},
			{
				text: [
					{ text: '3.- COMISI??N POR APERTURA DE "EL CR??DITO".- "EL ACREDITADO" ', bold: true },
					'se obliga a pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'por ??nica vez mientras dure la vigencia de este cr??dito equivalente ',
					generales.comisionAdmon,
					' del monto de cr??dito. Para obtener el monto de la comisi??n a pagar debe multiplicarse el cr??dito otorgado se??alado en la cl??usula segunda de este contrato por el ',
					generales.comisionAdmon,
					' equivalente a ',
					generales.montoComAdm,'.\n\n'
				],
			},
			{
				text: [
					{ text: '4.-SEGURO DE VIDA.- ', bold: true },
					'Con el fin de favorecer la cultura financiera y contar con protecci??n econ??mica en caso de fallecimiento',
					{ text: '"EL ACREDITADO" ', bold: true },
					'deber?? contratar por su cuenta y orden el Servicio de Seguro de Vida o solicitar el apoyo en su contrataci??n a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					', raz??n por la cual, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'faculta a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a que efect??e los cobros correspondientes para el pago de las primas que se generen y deslinda a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de cualquier responsabilidad, da??o o perjuicio que la Empresa Aseguradora ocasione a ???EL ACREDITADO??? por falta de indemnizaci??n del Seguro de Vida. El costo de prima anual ser?? de ',
					generales.coberturaSeguro,
					' para una suma asegurada de ',
					generales.primaSeguro,
					'. Los detalles del aseguramiento se establecer??n en la p??liza correspondiente.\n',

					'El seguro de vida ampara a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'ante el fallecimiento por muerte natural durante un a??o de vigencia a partir de la fecha de expedici??n de la P??liza de Seguro de Vida emitida por la Empresa Aseguradora. No ampara cobertura por muerte  de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'causada  por enfermedad cr??nica degenerativa y enfermedad terminal como ???C??ncer???, ???Diabetes???, ???Hipertensi??n???, Alcoholismo, u otra causa que establezca la Empresa Aseguradora de acuerdo a las Leyes de la Rep??blica Mexicana que la rigen. La fecha de emisi??n de la P??liza de Seguro de Vida podr?? ser hasta de 30 d??as posteriores a la fecha de contrataci??n del presente contrato de cr??dito. El periodo de tiempo entre la contrataci??n de este instrumento de cr??dito y la fecha de emisi??n de la p??liza, reconoce y acepta ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'que no est?? protegido por la Cobertura de Seguro de Vida en caso de muerte.\n',

					'El costo de la prima del seguro de vida estar?? establecido por la Empresa Aseguradora y ser?? descrito en la P??liza de Seguro de Vida que ??sta emita. La Forma y t??rminos del contrato de seguro de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'; ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'declara conocerlo y entenderlo, y cuyos derechos se subrogan de manera irrevocable a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'mismos que est??n descritos en la Autorizaci??n que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'otorgue en el Consentimiento ???Seguro de Vida Grupo Diversos??? o en cualquier otro formato de Solicitud de Seguro de Vida que emita para tal fin la Empresa Aseguradora prestadora del Servicio. La vigencia del Seguro es de un a??o a partir de la emisi??n de la p??liza de vida por parte de la Aseguradora y el "EL ACREDITADO??? autoriza a la ???LA ACREDITANTE??? el cobro de la prima para que por su cuenta y orden pague a la Aseguradora la cuota correspondiente en los a??os subsecuentes de vigencia del cr??dito y/o hasta que se liquide totalmente el saldo insoluto del mismo.\n\n'
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
					{ text: 'POR CIENTO ANUAL M??S I.V.A. ', bold: true },
					'a Tasa Fija y para fines informativos y de comparaci??n exclusivamente.\n\n'
				],
			},
			{
				text: [
					{ text: '6.- GASTOS Y HONORARIOS.- ', bold: true },
					'Todos los gastos, derechos y honorarios, que se causen por el otorgamiento y ejecuci??n de este contrato incluyendo  los gastos de contrataci??n en el Registro P??blico de Comercio y Registro P??blico de la Propiedad, sus consecuencias y actos complementarios, as?? como su cancelaci??n, cuando procedan ser??n por cuenta de ',
					{ text: '"EL ACREDITADO"', bold: true },
					', quien se obliga a pagarlos en el momento en que se  causen.\n\n'
				]				
			},
			{
				text: [
					{ text: '7.- GARANT??A FEGA.- "EL ACREDITADO" ', bold: true },
					'est?? de acuerdo en pagar el costo por concepto de Garant??a FEGA que otorga FIRA, el cual representa el 0.00% (Cero punto Cero) por ciento anual m??s I.V.A. para cr??ditos de ',
					{ text: 'Habilitaci??n o Av??o ', bold: true },
					'y el ',
					garantiaFira(catTipoConsultaGarFIRA.refaccionarioFEGA, garantiasFira),
					' anual para cr??ditos ',
					{ text: 'REFACCIONARIOS ', bold: true },
					'multiplicados por el monto del cr??dito, multiplicados por el periodo de vigencia de cada amortizaci??n.\n\n',

					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'dejare de efectuar dichos pagos, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'podr?? hacerlos por cuenta del propio ',
					{ text: '"ACREDITADO" ', bold: true },
					'que deber?? reembolsarle el importe de los mismos m??s intereses moratorios m??s I.V.A. a la tasa estipulada.\n\n'

				],
				
			},
			{ // Clausula Sexta
				text: [
					{ text: 'SEXTA.- PLAZO Y FORMA DE PAGO.- "EL ACREDITADO" ', bold: true },
					'sin necesidad de previo requerimiento, se obliga a pagar a ',
					{ text: '"LA ACREDITANTE"', bold: true },
					'el importe del Cr??dito dispuesto, los intereses m??s IVA estipulados y las dem??s sumas que resulten a su cargo derivadas del presente contrato, en un plazo de ',
					{ text: generales.plazo, bold: true },
					', de acuerdo al siguiente calendario de amortizaciones.\n\n'
				]
			},
			{ // Tabla C - Amortizaciones.
				text: 'TABLA DE AMORTIZACI??N\n',
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
					', se aplicar?? en el siguiente orden: Gastos y Costas, Impuestos, honorarios, derechos de registro, cuotas de seguro de vida, intereses moratorios, intereses ordinarios, financiamientos adicionales y por ??ltimo capital.\n\n',

					'La falta de pago de una de las amortizaciones mencionadas, ser?? causa de vencimiento anticipado y cancelaci??n del presente contrato. No obstante la terminaci??n del plazo, este contrato surtir?? plenamente sus efectos legales, hasta que ',
					{ text: '"EL ACREDITADO"', bold: true },
					'haya dado cumplimiento a todas las obligaciones a su cargo.\n\n'
				]
			},
			{ // Clausula Septima
				text: [
					{ text: 'S??PTIMA.- LUGAR, FORMA DE ENTREGA Y PAGO DE "EL CR??DITO". "EL ACREDITADO" ', bold: true },
					'pasar?? personalmente a recoger el importe de su pr??stamo a las oficinas de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'el cual recibir?? mediante cheque o transferencia interbancaria a la cuenta que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'autorice a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'el dep??sito; o de manos del cajero previa identificaci??n con documento oficial.\n\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'sin necesidad de requerimiento o cobro previo por ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se obliga a pagar en pesos mexicanos a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de conformidad con este contrato y de los pagar??s en su caso, el pago de capital, intereses, impuestos, y comisiones de las amortizaciones descritas en la Tabla ???C??? de este instrumento. Ser??n pagaderas en la caja o en la cuenta bancaria y en las Sucursales, que para ello determine ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'mediante entregas en efectivo, cheque o transferencia electr??nica, pero de estos no se aplicar?? su importe sino hasta que hubieren sido cobrados.\n',

					'Los pagos que realice ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'ser??n en las fechas convenidas en d??as y horas h??biles dentro del horario de atenci??n al p??blico. En caso de que el d??a de pago fuere d??a no h??bil, la fecha de vencimiento de dicho pago se pospondr?? al d??a h??bil inmediato posterior del d??a en que deba efectuarse el pago de conformidad a la cl??usula sexta de este contrato, sin cargo alguno.\n',

					'Cada pago deber?? acreditarse de acuerdo al medio de pago que se utilice, de la manera siguiente:'
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
						{ text: 'Se acreditar?? el mismo d??a depositado antes de las 12:00 horas del d??a'},
					],
					[
						{ text: 'Cheque'},
						{ text: 'Cheque Del mismo banco depositado antes de las 12:00 horas del d??a, se acreditar?? el mismo d??a. Cheque de otro banco, depositado antes de las 12:00 horas, se acreditar?? a m??s tardar el D??a H??bil siguiente; y despu??s de las 12:00 horas, se acreditar?? a m??s tardar el segundo D??a H??bil siguiente.'},
					]
				]
				},				
				margin: [0, 20, 0, 0]
			},
			{
				text: [
					'\nLo anterior en el entendido de que en todo caso, las cantidades correspondientes deber??n quedar perfecta y absolutamente liberadas y disponibles a satisfacci??n de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en su cuenta bancaria, a m??s tardar a las 12:00 (doce) horas (hora de la Ciudad de M??xico, Distrito Federal) del d??a en que deba hacerse el pago correspondiente, pues de lo contrario, aquellos pagos que efectivamente se hayan acreditado fuera de dicho horario, se considerar??n hechos el D??a H??bil siguiente, con la consecuente generaci??n de intereses moratorios m??s I.V.A., en su caso.\n\n',
				]
			},
			{ // Clausula Octava
				text: [
					{ text: 'OCTAVA.- ESTADOS DE CUENTA Y SALDO. "EL ACREDITADO" y "LA ACREDITANTE" ', bold: true },
					'acuerdan que el primero consultar?? personalmente o v??a telef??nica con su Ejecutivo de Cr??dito los saldos o estados de cuenta correspondientes, en las sucursales y/o casa Matriz de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en los horarios que la entidad tiene para la atenci??n al p??blico con un horario matutino de las 8:30 horas a las 14:00 y un vespertino de las 15:30 a las 18:00, de lunes a viernes. Los estados de cuenta podr?? consultarlos ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'cada mes seg??n su programa de pagos el cual se establece en la cl??usula sexta de este contrato. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'dispondr?? de tres d??as h??biles para objetar o solicitar cualquier aclaraci??n de su saldo.\n\n',

					'Una vez que',
					{ text: '"EL ACREDITADO" ', bold: true },
					'liquide totalmente el saldo insoluto del cr??dito, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'est?? obligada a reportar a las Sociedades de Informaci??n Crediticias ???SICS??? a m??s tardar el d??a 10 del mes siguiente respecto del mes en el cual se liquid?? el cr??dito, que la cuenta de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'est?? cerrada sin adeudo alguno.\n\n',

					'En este caso, o para cualquier solicitud, consulta, aclaraci??n, inconformidad y/o queja, relacionada con la operaci??n o servicio contratado ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'podr?? llamar o acudir a la ',
					{ text: 'Unidad Especializada de Atenci??n a Usuarios ', bold: true },
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
					'est?? obligada a aceptar pagos anticipados de los cr??ditos menores al equivalente a 900,000 UDIS, siempre que los Usuarios lo soliciten y  est??n al corriente en los pagos exigibles de conformidad con el contrato respectivo. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'podr?? hacer pagos anticipados a cuenta de capital, o bien podr?? liquidarlo ??ntegramente antes de su vencimiento, siempre y cuando dicho pago anticipado se presente con un m??nimo de un mes de anticipaci??n y sea por una cantidad igual o mayor al pago que deba realizarse en el periodo correspondiente incluyendo la totalidad de refinanciamientos e intereses normales m??s I.V.A. del ??ltimo per??odo, entendi??ndose por ??ste, los d??as transcurridos entre la ??ltima amortizaci??n realizada y la fecha en que ocurra dicho pago anticipado. ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'aplicar?? los pagos anticipados al saldo insoluto del cr??dito. Cada vez que el ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'realice un pago anticipado, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'deber?? entregarle un comprobante de dicho pago, en f??sico, o en electr??nico. En caso de que el',
					{ text: '"EL ACREDITADO" ', bold: true },
					'tenga un saldo a favor despu??s de liquidar totalmente el cr??dito en cuesti??n,',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'le informar?? a ???EL ACREDITADO??? por medio escrito, electr??nico o telef??nico que tiene un saldo a favor y por lo tanto deber?? proporcionar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'los datos de cuenta bancaria para la devoluci??n v??a transferencia electr??nica bancaria, o bien o bien v??a cheque si as?? lo solicita.\n\n'
				]
			},
			{ // Clausula Decima
				text: [
					{ text: 'DECIMA.- FINANCIAMIENTO ADICIONAL.- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no pudiere cubrir oportunamente sus pagos de intereses m??s I.V.A., ???LA ACREDITANTE??? le conceder?? financiamientos adicionales por los mismos montos de los pagos que tuviere que hacer, con excepci??n del que coincida con la amortizaci??n m??s pr??xima de capital, los cuales los cubrir?? ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'en las fechas de vencimiento de la amortizaci??n de capital m??s pr??xima a la fecha del otorgamiento del financiamiento adicional.\n',

					'Las partes convienen en que los financiamientos adicionales, se otorgar??n bajo las mismas circunstancias y condiciones crediticias, tanto de tasa, plazo, como de forma de pago de intereses m??s I.V.A. pactados en el Cr??dito materia del presente contrato, asimismo, se pacta que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'cubrir?? el importe de dichos financiamientos en la fecha de vencimiento de las amortizaciones de capital del Cr??dito motivo del presente contrato, cuando realice un pago anticipado, a los 365 (TRESCIENTOS SESENTA Y CINCO) d??as contados a partir de la primera disposici??n del cr??dito o a la ??ltima fecha en que fueron exigibles estos financiamientos adicionales.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'queda obligado a pagar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'con sus propios recursos, precisamente el d??a en que venzan las amortizaciones de capital, los intereses m??s I.V.A. devengados por los d??as transcurridos del mes en que ocurran dichos vencimientos, tanto por el cr??dito inicial al que mencione la cl??usula segunda del presente contrato, como por los financiamientos adicionales.\n\n'
				]
			},
			{ // Clausula Decima Primera
				text: [
					{ text: 'DECIMA PRIMERA.- GARANT??AS.- ', bold: true },
					'En cumplimiento de todas y cada una de las obligaciones derivadas del presente contrato, se constituye a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'las siguientes:'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{text: [ // Garant??a espec??fica
						{ text: 'Garant??a espec??fica.', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente contrato y de los ???Pagar??s???, y especialmente para garantizar el pago del Cr??dito, su suma principal, intereses ordinarios y moratorios m??s I.V.A., en su caso, comisiones, costos, gastos y todas y cada una de las dem??s cantidades pagaderas por ', { text: '"EL ACREDITADO" ', bold: true},'a ',{ text: '"LA  ACREDITANTE".\n', bold: true},
						
						{ text: '"EL ACREDITADO"', bold: true},'constituye a favor de ', { text: '"LA ACREDITANTE" ', bold: true},'un gravamen en primer lugar sobre los bienes destino del cr??dito, tal y como los mismos se describen en los siguientes incisos de la presente cl??usula del presente contrato el cual por esta referencia se tienen aqu?? por reproducidos como si literalmente se insertasen a la letra, y sobre todos los bienes de su empresa, con los frutos y productos futuros pendientes o ya obtenidos, en los t??rminos de los art??culos 324, 332, 333, 334, Fracci??n VII y dem??s aplicables de la Ley General de T??tulos y Operaciones de Cr??dito, en el entendido de que el valor comercial de los mismos siempre deber?? guardar la proporci??n excedente al saldo insoluto del Cr??dito, en el porcentaje que el acreditado se obliga a aportar al ???Proyecto??? de conformidad con lo establecido en la Cl??usula Tercera del presente.\n',

						'Esta garant??a se extender?? a las garant??as y acciones naturales de la empresa, a sus mejoras, a los bienes que en el futuro lleguen a formar parte de la empresa. ', { text: '"EL ACREDITADO" ', bold: true},'ser?? depositario de los bienes gravados en los t??rminos del art??culo 329 de la Ley General de T??tulos y Operaciones de Cr??dito.\n\n'
					]},

					{text: [ // Garant??a Prendar??a.
						{ text: 'Garant??a Prendar??a. ', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los "Pagares", y especialmente para garantizar el pago del Cr??dito, su suma principal, intereses ordinarios y moratorios m??s I.V.A., en su caso, comisiones, costos, gastos y todas y cada una de las dem??s cantidades pagaderas por ', { text: '"EL ACREDITADO" ', bold: true},'a ',{ text: '"LA ACREDITANTE", "EL GARANTE PRENDARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true},', con el consentimiento (en su caso) de su (s) c??nyuge(s), el (los) se??or (es): ',{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' constituye(n) a favor de ',{ text: '"LA ACREDITANTE" ', bold: true },' un gravamen en primer lugar sobre el(los) bien(es) mueble(s) descritos a continuaci??n:\n\n',

						creaTablaMobiliarias(garantiasGarantes, catTiposGarantia.prendaria)
					]},

					{text: [ // Garant??a Hipotecaria.
						{ text: 'Garant??a Hipotecaria. ', bold: true},'En garant??a del cumplimiento de todas y cada una de las obligaciones derivadas de este contrato, de los ???Pagares??? y de la Ley o de resoluciones judiciales dictadas a favor de ', { text: '"LA ACREDITANTE" ', bold: true},'y a cargo de ',{ text: '"EL ACREDITADO"', bold: true},', especialmente el pago de ',{ text: '"EL CR??DITO"', bold: true},', su suma principal, intereses ordinarios y moratorios m??s I.V.A., comisiones, gastos y dem??s accesorios, as?? como los gastos y costas en caso de juicio, el (los) ',{ text: '"GARANTE (S) HIPOTECARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true},', con el consentimiento (en su caso) de su(s) c??nyuge(s), el (los) se??or (es): ',{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' constituye(n) a favor de ',{ text: '"LA ACREDITANTE", HIPOTECA EXPRESA EN PRIMER  LUGAR  Y GRADO ', bold: true }, 'sobre el(los) inmueble(s) cuyas caracter??sticas quedan descritas en el p??rrafo siguiente:\n\n',

						creaTablaMobiliarias(garantiasGarantes, catTiposGarantia.hipotecaria),

						'En dicha hipoteca se comprende todo cuanto enumeran los art??culos 2896 y 2897 del C??digo Civil Federal y sus correlativos del C??digo Civil de cualquier Estado de la Rep??blica Mexicana y especialmente el terreno constitutivo del predio, los edificios y cualesquiera otras construcciones existentes al tiempo de hacerse ',{ text: '"EL CR??DITO" ', bold: true },'o edificados con posterioridad a ??l; en forma enunciativa y no limitativa sus accesiones naturales y las mejoras hechas, los objetos muebles incorporados permanentemente, la indemnizaci??n eventual que se obtenga por seguro en caso de destrucci??n, garantizando a ',{ text: '"LA ACREDITANTE" ', bold: true },'el pago del capital y de todas las prestaciones e intereses, aunque ??stos ??ltimos excedan del t??rmino de 3 a??os, de acuerdo con el art??culo 2915 del C??digo Civil Federal y su correlativo del C??digo Civil de cualquier Estado de la Rep??blica Mexicana, de  lo que se tomar?? raz??n especial en el Registro P??blico de la Propiedad respectivo.\n',

						'Con la hipoteca aqu?? constituida se garantiza el importe total de ', { text: '"EL CR??DITO" ', bold: true },'y sus accesorios, no obstante que se reduzca la obligaci??n garantizada, por lo cual la ',{ text: '"EL ACREDITADO" ', bold: true },'renuncia expresamente al beneficio de la liberaci??n y divisi??n parcial a que se refieren los art??culos 2912 y 2913 del C??digo Civil Federal y sus correlativos del C??digo Civil de cualquier Estado de la Rep??blica Mexicana, mismos que manifiestan conocer a la letra, por lo que resulta innecesaria su transcripci??n literal.\n',

						'La hipoteca que se constituye, permanecer?? vigente y subsistente por todo el tiempo en que ',{ text: '"EL ACREDITADO" ', bold: true },'adeude cualquier prestaci??n proveniente del aludido contrato de apertura de cr??dito simple que se consigna en este instrumento.\n',

						{ text: '"EL ACREDITADO" ', bold: true },'se obliga a notificar a ',{ text: '"LA ACREDITANTE"', bold: true },', cualquier cambio en el nombre de la calle, n??mero oficial, n??mero interior, colonia, Municipio en que se ubique el inmueble materia de la hipoteca, en un t??rmino no mayor a veinte d??as h??biles a partir de que suceda; sin que esos cambios, en caso de darse, impliquen alteraci??n o modificaci??n en forma alguna de la citada garant??a hipotecaria.',

						'Sin consentimiento de ',{ text: '"LA ACREDITANTE" ', bold: true },'no podr?? darse en arrendamiento el predio hipotecado, ni pactarse pago anticipado de rentas, de acuerdo con el art??culo 2914 del C??digo Civil Federal y su correlativo del C??digo Civil de cualquier Estado de la Rep??blica Mexicana.\n\n'
					]},

					{text: [ // Garant??a Usufructuaria.
						{ text: 'Garant??a Usufructuaria. ', bold: true},'A efecto de garantizar el fiel cumplimiento de todas y cada una de las obligaciones que a su cargo se derivan del presente Contrato y de los ???Pagares???, y especialmente para garantizar el pago del Cr??dito, su suma principal, intereses ordinarios y moratorios m??s IVA, en su caso, comisiones, gastos y costas y todas y cada una de las dem??s cantidades pagaderas por ',{ text: '"EL ACREDITADO" ', bold: true },'a ',{ text: '"LA ACREDITANTE"', bold: true },', el (los) ',{ text: '"GARANTE (S) USUFRUCTUARIO (S) Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true },', con el consentimiento (en su caso) de su(s) c??nyuge(s), el (los) se??or (es): ',{text:textoGarantiasUsufructuaria(garantiasGarantes)},' otorga en custodia a ',{ text: '"LA ACREDITANTE" ', bold: true },'los Certificados Parcelarios expedidos por el Registro Agrario Nacional  RAN, Constancias de Derechos Agrarios de parcelas ejidales y Constancias de Propiedad Ejidal, Documentos Originales que amparan las propiedades descritas en este inciso, a ',{ text: '"LA ACREDITANTE" ', bold: true },'la cual en caso de incumplimiento de  ',{ text: '"EL ACREDITADO"', bold: true },', realizar?? las gestiones legales y administrativas que permitan el traslado del Derecho Real de Usufructo de dichos bienes, hasta por el tiempo necesario para recuperar todas las prestaciones a que pudiera verse obligado ',{ text: '"EL ACREDITADO" ', bold: true }, 'en caso de incumplimiento de lo estipulado en este contrato. Dichos bienes inmuebles se describen a continuaci??n:\n\n',

						creaTablaGarantiasUsufructuaria(garantiasGarantes),

						'El valor de los bienes que constituyen la garant??a hipotecaria, prendaria y/o usufructuaria, aqu?? consignada deber?? guardar en todo tiempo una ', { text: '"Proporci??n m??nima de" ', bold: true },{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) ', bold: true },'en relaci??n con el importe del cr??dito que se consigna en el presente contrato.\n',

						'Las garant??as establecidas en la presente cl??usula, no podr??n restringirse ni cancelarse mientras que resulte alg??n saldo a favor de ',{ text: '"LA ACREDITANTE" ', bold: true },' y a cargo de',{ text: '"EL ACREDITADO" ', bold: true },' ya sea por el cr??dito concedido o dem??s accesorios pactados, bien porque no haya llegado a su vencimiento, ya porque ',{ text: '"LA ACREDITANTE" ', bold: true },'hubiera otorgado espera y a??n porque el adeudo se hubiere documentado en nuevos t??tulos de cr??dito.\n\n'
					]},

					{text: [ // Garant??a Liquida
						{ text: 'Garant??a Liquida: "EL ACREDITADO" ', bold: true},'aporta en garant??a liquida un monto de dinero equivalente a ',generales.montoGarLiquida,' el cual corresponde al ', generales.porcGarLiquida, ' por ciento del importe del cr??dito. El dep??sito deber?? realizarse previo a la ministraci??n del cr??dito en la cuenta de banco que ',{ text: '"LA ACREDITANTE" ', bold: true },'defina. ',{ text: '"EL ACREDITADO" ', bold: true },'est?? de acuerdo en que de presentarse alg??n atraso en cualesquiera de sus amortizaciones, esta garant??a se aplicar?? totalmente como abono al cr??dito hasta donde alcance su importe, por lo que faculta a ',{ text: '"LA ACREDITANTE" ', bold: true },'para su aplicaci??n sin necesidad de previo aviso a ',{ text: '"EL ACREDITADO".\n', bold: true },

						{ text: '"EL ACREDITADO" ', bold: true },'se obliga solidaria e ilimitadamente en favor de ',{ text: '"LA ACREDITANTE" ', bold: true }, ' por todas y cada una de las obligaciones que deriven del presente contrato, conviniendo expresamente desde este momento, en no invocar por ninguna causa o motivo la divisi??n de deuda, renunciando al efecto en cuanto pudiera favorecerle a lo dispuesto por el art??culo 1989 mil novecientos ochenta y nueve del C??digo Civil Federal, aplicable supletoriamente y su correlativo del C??digo Civil del Estado de Jalisco.\n\n',

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
					
					' constituy??ndose el dep??sito en los domicilios se??alados en sus generales quienes en este acto aceptan el cargo de Depositario y protestan su fiel y legal desempe??o.\n\n',

					'El Depositario se??ala como lugar para la guarda de los bienes pignorados y depositados, el domicilio se??alado en la cl??usula trig??sima tercera y se considerar?? como Depositario Legal para los fines de su responsabilidad tanto civil como penal, en la inteligencia de que ',{ text: '"LA ACREDITANTE" ', bold: true },', podr?? en cualquier momento y sin expresi??n de causa, revocar el nombramiento del Depositario y en tal caso designar?? en sustituci??n del mismo a quien o a quienes estime pertinentes sin necesidad del consentimiento previo del Depositario removido. Los dep??sitos ser??n gratuitos.\n\n'
				]
			},
			{ // Clausula Decima Tercera.
				text: [
					{ text: 'D??CIMA TERCERA.- OBLIGACIONES DE "EL ACREDITADO". "EL ACREDITADO" ', bold: true },
					'se obliga de manera expresa, durante la vigencia del presente contrato a:',	
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Contratar y mantener vigente un seguro sobre los bienes materia de la garant??a de este contrato, contra todos los riesgos asegurables, por una suma asegurada que baste a cubrir el importe del cr??dito y sus accesorios, y en el cual se designe a ',{ text: '"LA ACREDITANTE" ', bold: true },' como beneficiario preferente, debiendo acreditar dicha contrataci??n con la p??liza correspondiente dentro de los cinco d??as h??biles que sigan a la fecha de este contrato.'] },

					{ text: [{ text: '"EL ACREDITADO" ', bold: true },'se obliga a comprobar a ',{ text: '"LA ACREDITANTE" ', bold: true },'con los recibos correspondientes, el pago de las primas relativas en el plazo se??alado en el p??rrafo anterior, quedando facultada ',{ text: '"LA ACREDITANTE"', bold: true },', en caso de omisi??n de ',{ text: '"EL ACREDITADO"', bold: true },', para dar por vencido anticipadamente el presente contrato.']},

					{ text: ['Permitir que ',{ text: '"LA ACREDITANTE" ', bold: true },'efect??e, en cualquier momento, inspecciones en su unidad de explotaci??n, as?? como tambi??n a exhibir toda la informaci??n contable y financiera, facturas, recibos y dem??s documentos que justifiquen las inversiones realizadas, as?? como cualquier otra informaci??n o documento que se requiera, dentro de un plazo no mayor de 5 cinco d??as h??biles contados a partir de la fecha en que ',{ text: '"LA ACREDITANTE" ', bold: true },'as?? lo requiera.']},

					{ text: [
						'Entregar a ',{ text: '"LA ACREDITANTE" ', bold: true },'y satisfacci??n de la misma, en forma trimestral a m??s tardar dentro de la ??ltima semana del tercer mes correspondiente, en el domicilio se??alado en la cl??usula Trig??sima Tercera del presente contrato, la siguiente informaci??n: \n',
						{ text: [' 1.- Informaci??n contable\n'] },
						{ text: [' 2.- Informaci??n financiera\n'] },
						{ text: [' 3.- Facturas, recibos y dem??s documentos que justifiquen las inversiones realizadas\n'] },
						{ text: [' 4.- Cualquier otra informaci??n o documento que se requiera.\n'] },
						'El que se programe trimestralmente la presentaci??n del informe no exime que la aplicaci??n del cr??dito se tenga que realizar m??ximo 30 treinta d??as despu??s de su disposici??n.'
					]},

					{ text: ['No vender, dar en arrendamiento ni en explotaci??n ni constituir gravamen alguno sobre los bienes que garantizan el cr??dito.']},
					
					{ text: ['Deber?? cuidar que el valor de los bienes otorgados en garant??a en este contrato guarden una proporci??n, en todo el tiempo de vigencia del presente instrumento, de ',{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) '},' en relaci??n con el monto del cr??dito otorgado y mientras existan saldos insolutos.']},
					
					{ text: ['Dar las facilidades necesarias para que ',{ text: '"LA ACREDITANTE" ', bold: true },' y/o Los Fideicomisos Instituidos con Relaci??n a la Agricultura (FIRA) para que el personal que ??ste designe, as?? como a los representantes de cualquier Instituci??n y Organismo Nacional o Internacional autorizados por ???FIRA??? proporcione la informaci??n respectiva que facilite la inspecci??n que deseen efectuar sobre las inversiones realizadas, proporcionado entre otros, los estados de contabilidad y dem??s documentos y datos inherentes que dicho fideicomiso solicite.']},
					
					{ text: [{ text: '"EL ACREDITADO" ', bold: true },'no podr??, mientras est?? en vigor el presente contrato, contratar ning??n cr??dito sin la previa autorizaci??n por escrito de ',{ text: '"LA ACREDITANTE".', bold: true },]},

					{ text: [{ text: '"EL ACREDITADO" ', bold: true }, 'se obliga a ???considerar y cumplir con el ordenamiento ecol??gico y con la preservaci??n y mejoramiento del medio ambiente, la protecci??n de las ??reas naturales, la previsi??n y el control de la contaminaci??n del aire, agua y suelo, as?? como las dem??s disposiciones previstas en la Ley General de Equilibrio Ecol??gico y Protecci??n del Medio Ambiente, vigente a la fecha de la firma del presente contrato, debiendo manejar racionalmente los recursos naturales, acatar las medidas y acciones dictadas por las autoridades competentes, y cumplir con las orientaciones y recomendaciones t??cnicas de FIRA y/o la persona que cualquiera de ellos designe???.']},

					{ text: ['Informar oportunamente al acreditante de cualquier acto o hecho que pueda afectar la recuperaci??n del financiamiento.\n\n']},
				]
			},
			{ // Clausula Decima Cuarta.
				text: [
					{ text: 'D??CIMA CUARTA.- ', bold: true },
					'En caso de que ',	
					{ text: '"LA ACREDITANTE" ', bold: true },
					'sea penalizada por la fuente fondeadora debido al incumplimiento a las obligaciones se??aladas en la Cl??usula D??cima Tercera del presente contrato. ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'ser?? responsable de todos y cada uno de los gastos y penalizaciones generados. Y bastar?? con una notificaci??n por escrito que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'envi?? a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'inform??ndole de los cargos que se realizaran por dicho concepto. Oblig??ndose ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'al pago de los mismos dentro de los siguientes 30 d??as, de no hacerlo generar?? el inter??s ordinario y el inter??s moratorio m??s I.V.A. del cr??dito otorgado hasta su total liquidaci??n.\n\n'					
				]
			},
			{ // Clausula Decima Quinta.
				text: [
					{ text: 'D??CIMA QUINTA.- RESTRICCI??N Y DENUNCIA.- ', bold: true },
					'De conformidad con lo dispuesto en el Art??culo 294 doscientos noventa y cuatro de la Ley General de T??tulos y Operaciones de Cr??dito, ',	
					{ text: '"LA ACREDITANTE" ', bold: true },
					', se reserva el derecho de restringir el plazo de disposici??n o el importe del Cr??dito referido, o ambos a la vez, o para denunciar el presente contrato, mediante simple comunicaci??n por escrito dirigida a ',
					{ text: '"EL ACREDITADO" ', bold: true },
					', quedando en consecuencia limitado o extinguido, seg??n sea el caso, el derecho de ??sta para hacer uso del saldo no dispuesto.\n\n'
				]
			},
			{ // Clausula Decima Sexta.
				text: [
					{ text: 'D??CIMA SEXTA.- INTERVENTOR.- "LA ACREDITANTE"', bold: true },
					', tendr?? en todo el tiempo el derecho de designar quien deber?? cuidar y vigilar el  cumplimiento de las obligaciones a cargo de ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'que emanen del presente contrato ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a dar a dicho interventor las facilidades necesarias para que ??ste cumpla con su funci??n, el cual tendr?? los derechos y obligaciones que las leyes aplicables establecen.\n\n'
				]
			},
			{ // Clausula Decima Septima.
				text: [
					{ text: 'D??CIMA S??PTIMA.- NEGOCIACI??N DE T??TULOS.- "LA ACREDITANTE".', bold: true },
					', Tendr?? la facultad para negociar con el Banco de M??xico en su car??cter de fiduciario del fideicomiso denominado Fondo Especial para Financiamientos Agropecuarios (FEFA) o (FIRA) el presente contrato o t??tulos de cr??dito derivado de los financiamientos que otorgue a ',	
					{ text: '"EL ACREDITADO"', bold: true },
					', aun antes de su vencimiento.\n\n'
				]
			},
			{ // Clausula Decima Octava.
				text: [
					{ text: 'D??CIMA OCTAVA.- TERMINACI??N ANTICIPADA O CAUSAS DE VENCIMIENTO.- "EL ACREDITADO".', bold: true },
					'reconoce y acepta expresamente que la celebraci??n del presente Contrato y el otorgamiento de ',
					{ text: '"EL CR??DITO" ', bold: true },
					'por parte de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se basa en la obligaci??n que adquiere ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' de cumplir con todas y cada una de las obligaciones asumidas bajo el presente Contrato, por lo que est?? de acuerdo en que el incumplimiento de cualquiera de dichas obligaciones, ser?? causa suficiente para que',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'est?? facultada para dar por vencido anticipadamente el plazo para el pago de ',
					{ text: '"EL CR??DITO" ', bold: true },
					'y sus accesorios, sin necesidad de demanda, protesto, reclamaci??n o notificaci??n de ninguna clase. En cuyo caso dichas cantidades ser??n debidas y pagaderas a la vista, en cualquiera de los supuestos siguientes:\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Incumplimiento de obligaciones de pago.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'no paga puntualmente la suma principal de ',{ text: '"EL CR??DITO"', bold: true },', los intereses m??s I.V.A. sobre el mismo o cualesquiera comisiones, costos o gastos que se causen en virtud del presente Contrato.'] },

					{ text: ['Incumplimiento del Contrato.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'ncumpliere con cualquiera de las obligaciones que a su cargo se derivan del presente Contrato Distinta de las de pago, y siempre que dicho incumplimiento no haya sido subsanado en un plazo de cinco (5 D??as H??biles a partir de la notificaci??n del incumplimiento por parte de la ',{ text: '"LA ACREDITANTE" ', bold: true }] },

					{ text: ['Falsedad de informaci??n y declaraciones.- Si cualquier informaci??n proporcionada a ',{ text: '"LA ACREDITANTE" ', bold: true },'por ',{ text: '"EL ACREDITADO" ', bold: true },'o cualquier declaraci??n de ??ste en los t??rminos del presente Contrato resultare falsa, o dolosamente incorrecta o incompleta.'] },

					{ text: ['Desv??o de recursos.- Si los recursos de ', { text: '"EL CR??DITO" ', bold: true }, 'se destinaren total o parcialmente a fines distintos a los estipulados en el presente Contrato.'] },

					{ text: ['Condiciones preferenciales.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'otorgare condiciones preferenciales a las de ',{ text: '"EL CR??DITO" ', bold: true },'con ',{ text: '"LA ACREDITANTE" ', bold: true },'a cualquier otro acreedor bajo cualquier otro financiamiento.'] },

					{ text: 
						[
						'Situaciones de Insolvencia o Intervenci??n.- Si ',{ text: '"EL ACREDITADO:"\n', bold: true },
							{ text: '(i) ', bold: true },'Solicita o fuese solicitada por un tercero, la declaraci??n de concurso mercantil o su equivalente, salvo que dicho procedimiento a juicio de ',{ text: '"EL ACREDITADO" ', bold: true },'fuere notoriamente improcedente, o si ',{ text: '"EL ACREDITADO" ', bold: true },'o cualquiera de sus subsidiarias acudiese a sus acreedores para, de alguna forma, reestructurar sus deudas;\n',

							{ text: '(ii) ', bold: true },'Fuere demandado o sujeto a alg??n procedimiento ante autoridad judicial o administrativa o de cualquier otro g??nero, que resulte o pudiera resultar en el embargo de bienes o activos, la intervenci??n o subasta de sus bienes, salvo que dicho embargo, a juicio de ',{ text: '"LA ACREDITANTE"', bold: true },', fuere notoriamente improcedente o pudiese ser impugnado por la ',{ text: '"EL ACREDITADO" ', bold: true },'de buena fe con posibilidades de ??xito, mediante los procedimientos adecuados.'
						] 
					},

					{ text: ['Expropiaciones y otras contingencias.- Si una parte substancial de los activos de ',{ text: '"EL ACREDITADO" ', bold: true },'fuere objeto de privaci??n de dominio, custodia o control, por expropiaci??n u otro acto similar por parte de cualquier autoridad gubernamental.'] },

					{ text: ['Condenas judiciales o administrativas.- Si en virtud de cualquier procedimiento judicial, laboral o administrativo se dictare sentencia, laudo o resoluci??n en contra de ',{ text: '"EL ACREDITADO" ', bold: true },'o de sus subsidiarias, en su caso, excepto en el caso de que se hayan creado reservas por una cantidad por lo menos igual a la cantidad condenada.'] },

					{ text: ['Contingencias fiscales y administrativas.- Si ',{ text: '"EL ACREDITADO" ', bold: true },'dejare de pagar sin causa justificada cualquier adeudo fiscal correspondiente a su empresa o a sus propiedades, las cuotas o aportaciones correspondientes al IMSS o al INFONAVIT, o al SAR.'] },
					
					{ text: ['Disminuci??n de la Solvencia Econ??mica o Calidad Crediticia.- Si la solvencia o calidad o calificaci??n crediticia de ',{ text: '"EL ACREDITADO" ', bold: true },' o de cualquiera de sus subsidiarias, a juicio de ',{ text: '"LA ACREDITANTE" ', bold: true },'se ve reducida sustancialmente como consecuencia de su participaci??n, de cualquier modo, en cualquiera de los actos a que se refiere el p??rrafo anterior o en cualquier cesi??n de activos y/o pasivos.'] },

					{ text: ['Procedimientos en contra.- Si instituye procedimiento judicial o administrativo en contra de ',{ text: '"LA ACREDITANTE" ', bold: true },'de cualquiera de sus subsidiarias o de cualquiera de sus Directores Generales, consejeros, accionistas o empleados.'] },

					{ text: ['Deteriorare las garant??as de pago, no guardando una proporci??n de ',{ text: parseFloat(generalesAgro.proporcionGar).toFixed(2)+' a 1 ('+generalesAgro.proporcionLetra+' A UNO) '},' respecto del saldo insoluto del cr??dito, no las mejore o no efect??e el pago de la suma que se requiera para establecer la necesaria proporci??n entre dicho valor y el saldo insoluto.'] },

					{ text: 
						[
							'Si abandonara la administraci??n de la empresa o no la atendiere con el debido cuidado y eficiencia a juicio del interventor.\n',
							'En el supuesto de que ',{ text: '"EL ACREDITADO" ', bold: true },' prefiera los servicios profesionales de una persona f??sica o jur??dica diferente a ',{ text: '"LA ACREDITANTE" ', bold: true },', deber?? cubrir los servicios a ',{ text: '"LA ACREDITANTE" ', bold: true },', quien podr?? subcontratar los servicios de terceros, reserv??ndose el derecho de calificar la solvencia moral y t??cnica de estos.'
						] 
					},

					{ text: 
						[
							'Garant??a hipotecaria.- Si ',{ text: '"EL ACREDITADO"', bold: true },':\n',
								{ text: 'i) ', bold: true },' Enajena o grava sin consentimiento expreso y por escrito de',{ text: '"LA ACREDITANTE"', bold: true },', el(los) bien(es) dado(s) en garant??a hipotecaria, o si el mismo se rente o se reciben rentas adelantadas;\n',
								{ text: 'ii) ', bold: true },' Si los bienes dados en garant??a son objeto de embargo total o parcial;\n',
								{ text: 'iii) ', bold: true },' Si no mantienen en buen estado de conservaci??n los bienes objeto de la garant??a;\n',
								{ text: 'iv) ', bold: true },' Si el(los) bien(es) dado(s) en garant??a hipotecaria resulta(n) insuficientes si su valor disminuyere con o sin culpa de ',{ text: '"EL ACREDITADO" ', bold: true },'reduci??ndose considerablemente su valor posteriormente a la celebraci??n de este contrato, a menos que dicho(s) bien(es) materia de la garant??a se sustituya(n) por otro(s) iguale(s) o de mayor valor al(los) otorgado(s) o ampli?? la garant??a a satisfacci??n de ',{ text: '"LA ACREDITANTE" ', bold: true },'\n',
								{ text: 'v) ', bold: true },' Si efect??a modificaciones al(los) bien(es) dado(s) en garant??a sin la autorizaci??n previa y por escrito de ',{ text: '"LA ACREDITANTE" ', bold: true },' y de la autoridad correspondiente.\n',
								{ text: 'vi) ', bold: true },' Si ',{ text: '"EL ACREDITADO" ', bold: true },' no asegura el bien dado en garant??a o no comprueba estar al corriente en el pago de las primas.\n',
								{ text: 'vii) ', bold: true },'Si no paga durante dos bimestres consecutivos, las contribuciones correspondientes a impuesto predial, derechos por servicio de agua, o cualquier otro impuesto o derecho aplicable por las autoridades al(los) inmueble(s) hipotecado(s).\n',
								{ text: 'viii) ', bold: true },'Si no comprueba a ',{ text: '"LA ACREDITANTE" ', bold: true },' cuando ??ste as?? lo solicite, estar al corriente en el pago de los impuestos y derechos mencionados en el inciso precedente.\n'
						] 
					},

					{ text: 
						[
							'Otros supuestos.- Si ocurre cualquier otra Causa de Vencimiento Anticipado prevista por la ley o por el presente Contrato, o en cualquier documento anexo o relacionado con el mismo.\n\n',

							'No obstante lo anterior, ',{ text: '"EL CR??DITO" ', bold: true },'se extinguir?? en los casos previstos por el art??culo 301 de la Ley General de T??tulos y Operaciones de Cr??dito. En caso de ocurrir alguna de las causas de vencimiento anticipado antes descritas, ',{ text: '"LA ACREDITANTE" ', bold: true },'podr?? declarar por vencido anticipadamente el plazo estipulado para el pago de ',{ text: '"EL CR??DITO" ', bold: true },'y dem??s accesorios establecidos en el presente instrumento y ',{ text: '"EL ACREDITADO" ', bold: true },'deber?? pagar a ',{ text: '"LA ACREDITANTE" ', bold: true },'de manera inmediata el importe total del saldo insoluto de ',{ text: '"EL CR??DITO" ', bold: true },'en menci??n y todas las dem??s cantidades que se adeuden en t??rminos de este contrato, caso en el cual el o los pagar??s que haya suscrito ',{ text: '"EL ACREDITADO" ', bold: true },'en esta fecha vencer??n y ser??n pagados de inmediato; en caso contrario, ',{ text: '"EL ACREDITADO" ', bold: true },'se obliga a pagar intereses moratorios m??s I.V.A. conforme a lo pactado en la Cl??usula Quinta del presente contrato. \n\n'
						] 
					}



				]
			},
			{ // Clausula Decima Novena.
				text: [
					{ text: 'DECIMA NOVENA.- FORMAS DE NOTIFICACI??N. "LA ACREDITANTE"', bold: true },
					'notificar?? por escrito en el domicilio que ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'haya se??alado para tal efecto, sobre cualquier modificaci??n del presente contrato de adhesi??n, respecto de la operaci??n o servicio que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' tenga contratado, se le har?? saber con cuarenta d??as naturales de anticipaci??n antes de su entrada en vigor, las nuevas bases de operaci??n. En el evento de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'no est?? de acuerdo con las modificaciones propuestas, podr?? solicitar la terminaci??n del Contrato de Adhesi??n hasta 60 d??as naturales despu??s de la entrada en vigor de dichas modificaciones, sin responsabilidad ni comisi??n alguna a su cargo, debiendo cubrir, en su caso, los adeudos que ya se hubieren generado a la fecha en que solicite dar por terminada la operaci??n o el servicio de que se trate. Una vez transcurrido el plazo se??alado sin que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'haya recibido comunicaci??n alguna por parte de ???EL ACREDITADO???, se tendr??n por aceptadas las modificaciones al Contrato de Adhesi??n.\n\n'
				]
			},
			{ // Clausula Vigesima.
				text: [
					{ text: 'VIG??SIMA.- DEL PROCEDIMIENTO DE CANCELACI??N. ', bold: true },
					'En caso de que ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					'quiera cancelar sus operaciones o servicios con la entidad, deber?? acudir personalmente con su Ejecutivo de Cr??dito a entregarle por escrito su solicitud de cancelaci??n, para que este a su vez realice los tr??mites correspondientes para tal efecto. Para que esto proceda, el cliente acreditar?? que no tiene saldos pendientes con la entidad sobre ninguno de los rubros que se se??alan en este contrato.\n\n'
				]
			},
			{ // Clausula Vigesima Primera.
				text: [
					{ text: 'VIG??SIMA PRIMERA.- REGLAS PARTICULARES DE EJECUCI??N.- ', bold: true },
					'En caso de incumplimiento de las obligaciones a cargo de ',	
					{ text: '"EL ACREDITADO" ', bold: true },
					', las partes convienen en que:\n\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['En caso de embargo, ',{ text: '"LA ACREDITANTE" ', bold: true }, 'no se sujetar?? al orden establecido en los art??culos 1395 mil trescientos noventa y cinco del C??digo de Comercio.'] },
					{ text: [{ text: '"LA ACREDITANTE" ', bold: true },'podr?? revocar el nombramiento del Depositario designado en este contrato y, en consecuencia, tomar posesi??n de los bienes gravados y nombrar depositario de los mismos.'] },
					{ text: ['- El emplazamiento y notificaciones se har??n en los domicilios se??alados en la cl??usula Trig??sima Tercera de este contrato.'] },
					{ text: ['- Para la venta o remate de los bienes embargados, servir?? de base en primera almoneda, el valor que resulte del aval??o que para ese efecto realice la Instituci??n de Cr??dito o el perito que designe ',{ text: '"LA ACREDITANTE".\n\n', bold: true }] }
				]
			},
			{ // Clausula Vigesima Segunda.
				text: [
					{ text: 'VIG??SIMA SEGUNDA.- CONDUSEF.- ', bold: true },
					'El presente contrato se encuentra registrado ante la Comisi??n Nacional para la Protecci??n y Defensa de los Usuarios de Servicios Financieros (CONDUSEF) con el n??mero de registro ',
					generales.reca,
					', misma que cuenta con el siguiente n??mero telef??nico de atenci??n a usuarios (0155-53400999 o LADA sin costo 01800-9998080), direcci??n en Internet (www.condusef.gob.mx) y correo electr??nico (opinion@condusef.gob.mx).\n\n'
				]
			},
			{ // Clausula Vigesima Tercera.
				text: [
					{ text: 'VIG??SIMA TERCERA.- IMPUESTOS.- ', bold: true },
					'En caso de que conforme a las Leyes fiscales y tributarias, la ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'deba pagar alg??n impuesto sobre intereses ordinarios, intereses moratorios y/o la comisi??n por apertura del cr??dito, ??sta se obliga a pagarlo a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'conjuntamente con los referidos conceptos.\n\n'
				]
			},
			{ // Clausula Vigesima Cuarta.
				text: [
					{ text: 'VIG??SIMA CUARTA.- ???EL GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO???.- ', bold: true },
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' ',
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' ',
					generalAvales.cadenaAvales,
					' de manera expresa y voluntaria se constituye(n) mediante este contrato como ',
					{ text: '"GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO" con "EL ACREDITADO" ', bold: true },
					'oblig??ndose solidaria e ilimitadamente entre s??, respecto de todas y cada una de las obligaciones a cargo de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'que se deriven de este contrato, conviniendo desde ahora expresamente en no invocar por ninguna causa ni motivo la divisi??n de la deuda, renunciando al efecto en cuanto pudiere favorecerle a los dispuesto en el art??culo 1989 del C??digo Civil Federal y su correlativo del C??digo Civil de cualquier Estado de la Rep??blica Mexicana, aplicable supletoriamente.\n\n'
				]
			},
			{ // Clausula Vigesima Quinta.
				text: [
					{ text: 'VIG??SIMA QUINTA.- DISCREPANCIA EN EL NOMBRE.\n', bold: true },
					
					{ text: '"ADMINISTRADOR GENERAL UNICO".- ', bold: true },consejoAdmon[0].nombreCompleto+aliasCliente(consejoAdmon[0].alias).toUpperCase(),'.\n',
					{ text: '"EL (LOS) GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO".- ', bold: true },
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.prendaria)},' ',
					{text: textoGarantiasPorTipo(garantiasGarantes, catTiposGarantia.hipotecaria)},' ',
					generalAvales.cadenaAvales,'.\n\n'
				]
			},
			{ // Clausula Vigesima Sexta.
				text: [
					{ text: 'VIG??SIMA SEXTA.- DESIGNACI??N DE PERITO VALUADOR.- ???EL ACREDITADO??? ', bold: true },
					'autoriza a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a designar un Perito valuador para que determine el valor del(los) bien(es) afectado(s) en garant??a hipotecaria, mismo(s) que qued??(aron) descrito(s) en clausulas anteriores de este contrato, llegado el caso que disminuya considerablemente el valor del(los) bien(es) motivo de garant??a hipotecaria o que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'proceda para el cobro de los saldos insolutos correspondientes con cargo a ',
					{ text: '"EL CR??DITO" ', bold: true },
					' que ampara el presente contrato, judicialmente ejercitando la v??a ejecutiva mercantil, la hipotecaria, la ordinaria o la que en su caso corresponda.\n\n'
				]
			},
			{ // Clausula Vigesima Septima.
				text: [
					{ text: 'VIG??SIMA S??PTIMA.- SEGURO DE DA??OS.- ', bold: true },
					'Tanto ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'como el(los) ',
					{ text: '"GARANTE HIPOTECARIO, GARANTE PRENDARIO, GARANTE USUFRUCTUARIO Y AVAL U OBLIGADO SOLIDARIO" ', bold: true },
					'se obligan a contratar por su cuenta dentro de los 10 diez d??as naturales que sigan a la fecha de firma de este instrumento, un seguro amplio contra los da??os que pueda sufrir el bien sobre el cual se constituye la hipoteca o prenda y que por su naturaleza sean asegurables, designando como beneficiario preferente e irrevocable a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'debiendo acreditar los t??rminos de dicha contrataci??n a satisfacci??n de ??sta, quedando la p??liza respectiva en poder de ',
					{ text: '"LA ACREDITANTE".\n', bold: true },
					
					'El seguro en cuesti??n deber?? corresponder al valor real de construcci??n asegurable del inmueble hipotecado, de tal manera que en todo momento se encuentren garantizados el capital, intereses m??s I.V.A. y dem??s prestaciones y accesorios legales.\n',

					'En la p??liza de seguro se har?? constar expresamente para los efectos del art??culo 109 de la Ley Sobre el Contrato de Seguro, que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'ha obtenido el importe de ',
					{ text: '"EL CR??DITO" ', bold: true },
					'para destinarlo a los fines indicados en la Cl??usula Tercera de este contrato, quedando obligada a dar oportunamente aviso de siniestro a la compa????a aseguradora en las formas aprobadas y con copia para ',
					{ text: '"LA ACREDITANTE".\n', bold: true },

					'De dicho contrato de seguro deber?? estar vigente y pagada la prima correspondiente en cada renovaci??n, en tanto exista cualquier saldo insoluto a cargo de ',{ text: '"EL ACREDITADO" ', bold: true },'quedando obligado ',{ text: '"EL ACREDITADO" ', bold: true },'a exhibir el o los recibos de pago de la prima correspondiente a este seguro, cada que lo solicite ',{ text: '"LA ACREDITANTE".\n', bold: true },

					'Si ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' no contrata el seguro o deja de pagar las primas correspondientes al mismo, ??ste faculta a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'para que lo haga por cuenta de ??ste, quedando obligado a reembolsar las cantidades que se hubieren pagado por su cuenta en un plazo no mayor de 30 treinta d??as naturales, cubriendo adem??s sobre dichas cantidades, los intereses m??s I.V.A. que se causen a la tasa moratoria convenida en los t??rminos del presente contrato; en el entendido de que ser?? facultad discrecional de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'optar por contratar o no la p??liza de seguro del bien (es) otorgado en garant??a.\n',

					'En caso de siniestro, la indemnizaci??n que cubra la compa????a aseguradora se aplicar?? a favor de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'en pago de las prestaciones que  ',
					{ text: '"EL ACREDITADO" ', bold: true },
					' le adeude hasta donde alcance.\n',

					'En el supuesto de que ya exista seguro sobre el bien en menci??n, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'se obliga a llevar a cabo las gestiones necesarias para consignar en la p??liza correspondiente como beneficiario preferente de manera irrevocable a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'debiendo entregarle en el plazo convenido en  el primer p??rrafo de esta Cl??usula, la p??liza respectiva.\n',

					{ text: '"EL ACREDITADO" ', bold: true },
					'sabe y acepta que en caso de reclamaci??n y hasta en tanto la aseguradora de que se trate realice el pago de la suma asegurada correspondiente, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'continuar?? obligada al pago del monto de ',
					{ text: '"EL CR??DITO" ', bold: true },
					'dispuesto, junto con los intereses m??s I.V.A. y dem??s accesorios previstos en este instrumento en los t??rminos y fechas pactadas; en el entendido de que tales obligaciones de pago subsistir??n a??n en caso de que la compa????a aseguradora rechace la reclamaci??n correspondiente y/o decline el pago respectivo; por lo que',
					{ text: '"EL ACREDITADO" ', bold: true },
					'libera a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'de cualquier tipo de responsabilidad relacionada con los pagos, procedimientos, montos y plazos del seguro a que se refiere este instrumento, debiendo en su caso ejercitar las acciones que considere necesarias ante la compa????a aseguradora correspondiente.\n\n'
				]
			},
			{ // Clausula Vigesima Octava.
				text: [
					{ text: 'VIG??SIMA OCTAVA.- CESI??N DEL CR??DITO.- ', bold: true },
					'Se pacta que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					', si as?? lo estima conveniente a sus intereses, podr?? ceder o en cualquier forma negociar, total o parcialmente, este cr??dito, sin que por ello, el mismo se entienda renovado en la parte  negociada.',
					{ text: '"EL ACREDITADO" ', bold: true },
					'acepta incondicionalmente la presente previsi??n, renunciando a ser notificada si la acreedora cediere el cr??dito a que se refiere este contrato.\n\n'
				]
			},
			{ // Clausula Vigesima Novena.
				text: [
					{ text: 'VIG??SIMA NOVENA.- CONSULTA DE SALDO Y EMISI??N DE ESTADOS DE CUENTA.- "EL ACREDITADO"', bold: true },
					', tiene derecho a recibir peri??dicamente informaci??n  relacionada al desglose de los pagos efectuados, En t??rminos del art??culo 13, p??rrafo tercero de la Ley de Transparencia y Ordenamiento de los Servicios Financieros, ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'renuncia expresamente a su derecho de recibir un estado de cuenta en su domicilio. Al respecto, las partes en este contrato pactan que en cualquier momento y en la sucursal que corresponda, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'entregar?? a ',
					{ text: '"EL ACREDITADO"', bold: true },
					', previa solicitud e identificaci??n de esta, un estado de cuenta, en el que de manera clara se indique el monto a pagar en el per??odo, en su caso, desglosado en capital, intereses y cualesquiera otros cargos, las tasas de inter??s ordinaria y moratoria expresadas en t??rminos anuales simples y en porcentaje, as?? como el monto de intereses m??s IVA a pagar, el saldo insoluto de ',
					{ text: '"EL CR??DITO"', bold: true },
					', el Costo Anual Total (CAT) m??s I.V.A. y dem??s requisitos en t??rminos del citado art??culo.\n\n'
				]
			},
			{ // Clausula Trigesima.
				text: [
					{ text: 'TRIG??SIMA.- PROCEDIMIENTO DE ACLARACIONES.- ', bold: true },
					'En caso de que ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'tenga alguna queja o aclaraci??n respecto de los movimientos que aparezcan en su estado de cuenta, podr?? presentar su aclaraci??n o queja por escrito a trav??s de cualquier sucursal de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'o a trav??s de la Unidad Especializada de Atenci??n al Usuario.\n'
				]
			},
			{
				type: 'lower-alpha',
				separator: ')',
				ol: [
					{ text: ['Cuando la',{ text: '"EL ACREDITADO" ', bold: true }, 'no est?? de acuerdo con alguno de los movimientos que aparezcan en el estado de cuenta respectivo podr?? objetarlo y presentar una solicitud de aclaraci??n dentro de un t??rmino de 15 Quince d??as naturales contados a partir de la fecha de corte o en su caso, de la realizaci??n de la operaci??n. Transcurrido dicho plazo sin haberse hecho objeci??n a la cuenta, los asientos que figuren en la contabilidad de ',{ text: '"LA ACREDITANTE" ', bold: true },'har??n prueba a favor de ??sta.'] },
					
					{ text: ['La solicitud respectiva podr?? presentarse ante la sucursal en la que se otorg??',{ text: '"EL CR??DITO"', bold: true },', o bien, en la Unidad Especializada de Atenci??n al Usuario de ',{ text: '"LA ACREDITANTE" ', bold: true },', mediante un escrito, correo electr??nico o cualquier otro medio por el que se pueda comprobar su recepci??n. ',{ text: '"LA ACREDITANTE" ', bold: true },'deber?? acusar de recibo de dicha solicitud y proporcionar?? el n??mero de expediente.'] },

					{ text: ['Trat??ndose de cantidades a cargo de ',{ text: '"EL ACREDITADO"', bold: true },', este podr?? dejar de hacer el pago de los cargos objetados en aclaraci??n, as?? como el de cualquier cantidad generada con motivo de ??stos, en tanto la aclaraci??n no sea resuelta por ',{ text: '"LA ACREDITANTE" ', bold: true }, 'conforme al presente procedimiento. Esta ??ltima incluir?? los cargos objetados en los estados de cuenta con una leyenda que indique que se encuentran sujetos a un proceso de aclaraci??n.']},
					
					{ text: ['Una vez recibida la solicitud de aclaraci??n, ',{ text: '"LA ACREDITANTE" ', bold: true },'tendr?? un plazo m??ximo de 15 Quince d??as naturales para entregar a',{ text: '"EL ACREDITADO" ', bold: true },'el dictamen correspondiente, anexando copia simple del documento o evidencia considerada para la emisi??n de dicho dictamen, el  cual contendr?? un informe detallado en el que se respondan todos los hechos contenidos en la solicitud presentada por ',{ text: '"EL ACREDITADO".', bold: true }] },
					
					{ text: ['El dictamen se formular?? por escrito y ser?? suscrito por alg??n funcionario facultado. En el caso de que, conforme al dictamen que emita',{ text: '"LA ACREDITANTE"', bold: true },', resulte procedente el cobro del monto respectivo, ',{ text: '"EL ACREDITADO" ', bold: true },'deber?? hacer el pago de la cantidad a su cargo, incluyendo los intereses ordinarios m??s I.V.A. conforme a lo pactado, sin que proceda el cobro de intereses moratorios m??s IVA y otros accesorios generados por la suspensi??n del pago.']},
					
					{ text: 
						[
							'En el t??rmino de 15 quince d??as naturales contados a partir de la entrega del dictamen en menci??n, ',{ text: '"LA ACREDITANTE" ', bold: true },'se obliga a poner a disposici??n de  ',{ text: '"EL ACREDITADO" ', bold: true },'en la sucursal donde radica ',{ text: '"EL CR??DITO"', bold: true },', el expediente generado con motivo de la solicitud, as?? como a  integrar a este, bajo su m??s estricta responsabilidad, toda la documentaci??n e informaci??n que, deban obrar en su poder y que se relacione directamente con la solicitud de aclaraci??n que corresponda.\n',

							'El procedimiento antes descrito es sin perjuicio del derecho de ',{ text: '"EL ACREDITADO" ', bold: true },'de acudir ante la Comisi??n Nacional para la Defensa de los Usuario de Servicios Financieros o ante la autoridad jurisdiccional correspondiente. Sin embargo, el procedimiento previsto en esta cl??usula quedar?? sin efectos a partir de que ',{ text: '"EL ACREDITADO" ', bold: true },'presente su demanda ante autoridad jurisdiccional o conduzca su reclamaci??n en t??rminos de la Ley de Protecci??n y Defensa al Usuario de Servicios Financieros.\n\n'
				
						]
					},
				]
			},
			{ // Clausula Trigesima Primera.
				text: [
					{ text: 'TRIG??SIMA PRIMERA.- ACCIONES.- ', bold: true },
					'Constituida la mora, ',
					{ text: '"LA ACREDITANTE"', bold: true },
					', podr?? en cualquier momento proceder al cobro judicial, corriendo por cuenta de ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'todos los gastos administrativos y/o judiciales, costas procesales y honorarios profesionales de abogados que se generen por el cobro judicial, dejando establecido que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'a elecci??n suya podr?? optar por cualquiera de los procedimientos establecidos por las leyes de la materia; en la inteligencia de que si optare por el procedimiento ejecutivo mercantil para exigir el pago de ',
					{ text: '"EL CR??DITO" ', bold: true },
					'y sus accesorios, ello no implica la p??rdida de las acciones reales que ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'tiene respecto del bien gravado, conforme a   las estipulaciones de este contrato.\n',

					'En el entendido de que si se sigue dicha v??a ejecutiva, ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					' podr?? se??alar los bienes suficientes para su  embargo, sin sujetarse al orden que establece el art??culo 1395 mil trescientos noventa y cinco del C??digo de Comercio.\n\n'
				]
			},
			{ // Clausula Trigesima Segunda.
				text: [
					{ text: 'TRIG??SIMA SEGUNDA.- AVISOS.- ', bold: true },
					'A menos que en este contrato se estipule lo contrario, las notificaciones o avisos que se contemplan en el mismo, se har??n y se enviar??n por correo electr??nico o se entregar??n a cada parte de este contrato en su domicilio, o a cualquier otro domicilio que cualquier parte se??ale en aviso por escrito dado a las dem??s partes de este contrato.\n\n'
				]
			},
			{ // Clausula Trigesima Tercera.
				text: [
					{ text: 'TRIG??SIMA TERCERA.- DOMICILIOS.- ', bold: true },
					'Para o??r y recibir todo tipo de notificaciones, las partes, respecto de todos los actos jur??dicos que se contienen en este instrumento designan para los efectos legales correspondientes los siguientes domicilios:\n\n',

					{ text: '"LA ACREDITANTE": ', bold: true },paramUEAU.direccionUEAU,'.\n\n',
					{ text: '"EL ACREDITADO": ', bold: true },generales.direccionCliente,'\n\n',
					
					{ text: '"EL (LOS) GARANTE (S) HIPOTECARIO (S), GARANTE PRENDARIO Y AVAL": \n', bold: true },
					
					{text: 
						listaGarantesAvales(listaGarantes, listaAvales)	
					},'\n\n',

					'Tanto ',
					{ text: '"EL ACREDITADO" ', bold: true },
					'como el(los) ',
					{ text: '"GARANTE(S) HIPOTECARIO(S), PRENDARIOS Y AVAL (ES) U OBLIGADO SOLIDARIO"', bold: true },
					', deber??n informar a ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'del cambio de su domicilio, por lo menos con 10 diez d??as h??biles de anticipaci??n. En caso de no hacerlo, todos los avisos, notificaciones y dem??s diligencias judiciales o extrajudiciales que se hagan en el domicilio indicado por las mismas, en esta cl??usula, surtir??n plenamente sus efectos.',

					'En el domicilio se??alado por',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'se encuentra la Unidad Especializada de Atenci??n a Usuarios, mediante la cual ',
					{ text: '"EL ACREDITADO" ', bold: true },
					', podr?? solicitar aclaraciones, consultas de saldo, movimientos, entre otros. El correo electr??nico de dicha Unidad es ',
					paramUEAU.correoUEAU,
					' con domicilio en ',
					paramUEAU.direccionUEAU,
					', Tel??fono 01 33 379 820 00, o lo podr?? hacer directamente en cualquier sucursal de ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'que exista en la Rep??blica Mexicana.\n\n'
				]
			},
			{ // Clausula Trigesima Cuarta.
				text: [
					{ text: 'TRIG??SIMA CUARTA.- T??TULOS DE LAS CL??USULAS.- ', bold: true },
					'Los t??tulos de las cl??usulas que aparecen en este contrato, se han puesto ??nica y exclusivamente para facilitar su lectura, por lo tanto, no definen ni limitan el contenido de las mismas. Para efectos de interpretaci??n de cada cl??usula, las partes deber??n atenerse exclusivamente a su contenido y de ninguna manera a su t??tulo.\n\n'
				]
			},
			{ // Clausula Trigesima Quinta.
				text: [
					{ text: 'TRIG??SIMA QUINTA.- MODIFICACIONES.- ', bold: true },
					'Cualquier modificaci??n, adici??n o aclaraci??n a los t??rminos del presente contrato s??lo podr??n llevarse a cabo previo acuerdo entre ',
					{ text: '"LAS PARTES".\n\n', bold: true }
				]
			},
			{ // Clausula Trigesima Sexta.
				text: [
					{ text: 'TRIG??SIMA SEXTA.- T??TULO EJECUTIVO.- ', bold: true },
					'De conformidad con lo dispuesto por los art??culos 87-E y 87-F de la Ley General de Organizaciones y Actividades Auxiliares del Cr??dito, el presente contrato conjuntamente con el estado de cuenta certificado por el Contador de ',
					{ text: '"LA ACREDITANTE"', bold: true },',  ser?? t??tulo ejecutivo, sin necesidad de reconocimiento de firma ni de ning??n otro requisito.\n\n'
				]
			},
			{ // Clausula Trigesima Septima.
				text: [
					{ text: 'TRIG??SIMA S??PTIMA.- LEGISLACI??N APLICABLE, INTERPRETACI??N Y JURISDICCI??N.- ', bold: true },
					'En relaci??n a la interpretaci??n, ejecuci??n y  cumplimiento del presente contrato, ??ste se regir?? e interpretar?? de acuerdo a las Leyes de los Estados Unidos Mexicanos, particularmente por lo previsto en la Ley General de T??tulos y Operaciones de Cr??dito y  sus Leyes Supletorias.\n\n'		
				]
			},
			{ // Clausula Trigesima Octava.
				text: [
					{ text: 'TRIG??SIMA OCTAVA.- JURISDICCI??N.- ', bold: true },
					'Para la interpretaci??n y cumplimiento del presente contrato, as?? como para el caso de cualquier controversia, litigio o reclamaci??n de cualquier tipo, en contra de cualquiera de las partes de este contrato, todos aceptan someterse expresamente a la jurisdicci??n y competencia de los tribunales competentes del Trig??simo primer partido judicial con sede en la cabecera municipal de Tlajomulco de Z????iga o de la ciudad de Guadalajara, Jalisco, renunciando clara y terminantemente al fuero que la ley concede, pudiendo ',
					{ text: '"LA ACREDITANTE" ', bold: true },
					'elegir de conformidad con la jurisdicci??n concurrente el fuero local o federal para dirimir cualquier controversia derivada del presente contrato. Todas las controversias que surjan con motivo del presente contrato de adhesi??n deber??n ser resueltas con base en lo se??alado en la Ley de Transparencia y Ordenamiento de los Servicios Financieros. Ley de protecci??n y defensa al usuario de servicios financieros y dem??s relativas y supletorias que la misma ley se??ala, siendo la comisi??n nacional, la competente para resolver su aplicaci??n e interpretaci??n.\n\n',

					'Para la interpretaci??n y cumplimiento del presente contrato, se deber?? sujetarse a lo dispuesto en el C??digo de Comercio, la Ley de T??tulos y Operaciones de Cr??dito y dem??s leyes mercantiles aplicables, y se aplicar?? supletoriamente a los ordenamientos mencionados solamente en el caso y a falta de disposiciones expresas el C??digo Civil Federal aplicado en forma supletoria.\n'
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
					generales.nomRepresentanteLeg,
					' declara por sus generales ser mexicano por nacimiento, naci?? el ',
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
					'Las partes manifiestan que en la celebraci??n del presente contrato no ha existido ning??n vicio del consentimiento, que pudiera ser causa de nulidad o rescisi??n de este contrato y si lo hubiere, desde este momento renuncian a la acci??n de nulidad que les pudiere corresponder, en testimonio de lo anterior, y conformes ',
					{ text: '"LAS PARTES" ', bold: true },
					'de que la car??tula de este instrumento y las cl??usulas anteriores son complementarias e integrantes de un mismo instrumento se firma por',
					{ text: '"LAS PARTES" ', bold: true },
					', por triplicado en Tlajomulco de Z????iga, Jalisco a los ',
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
					generales.nombreCliente+aliasCliente(generales.aliasCliente),
					{ text: 'REPRESENTADA EN ESTE ACTO POR EL C.', bold: false },
					'\n',
					'\n',
					'___________________________________',			
					consejoAdmon[0].nombreCompleto,
					'EN SU CAR??CTER DE ' + consejoAdmon[0].nombreCargo,
					{ text:generales.direccionCliente, bold: false }
				],
				bold: true,
				style: 'header',
				alignment: 'center',
			},
			{
				
				stack: [
							'\n\n',
							{ text:' POR "EL GARANTE PRENDARIO(S), GARANTE(S) HIPOTECARIO(S) O USUFRUCTUARIO(S)"', bold: true },
				        	firmantesGarantes(listaGarantes)
				        ],
				alignment: 'center'				
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
							{ text:' ???LOS TESTIGOS???', bold: true },
				
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
				ul:[ 'Garant??a liquida por el ' + 	generales.porcGarLiquida + ' del monto del cr??dito equivalente a ' + generales.montoGarLiquida]
			
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
		[{ text: 'NUMERO', bold: true, style: 'header'}, { text: 'FECHA DE AMORTIZACI??N', bold: true, style: 'header'}, { text: 'MONTO A AMORTIZAR A CAPITAL', bold: true, style: 'header'}]
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
		texto = '\nTambi??n conocido (a) indistintamente con el (los) nombre (s) de: '+parAlias;
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
			if(integrantes[i].nombre != ''){ 
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

	var_tablaConceptos.push([{ text: 'Con Recursos del Pr??stamo:', bold: true, style: 'header'}, { text: '', bold: true, style: 'header'},{ text: '', bold: true, style: 'header'}, { text: '', bold: true}]);

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
	
	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: 'Total Cr??dito', bold: true, style: 'header'},{ text: var_porcentajeRP+'%', bold: true, style: 'header', alignment: 'right'}, { text: parseFloat(generalesAgro.recursoPrestConInv).toFixed(2), bold: true, alignment: 'right'}]);
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

	var_tablaConceptos.push([{ text: '', bold: true, style: 'header'}, { text: 'Total Aportaci??n', bold: true, style: 'header'},{ text: var_porcentajeRS+'%', bold: true, style: 'header', alignment: 'right'}, { text: parseFloat(generalesAgro.recursoSoliConInv).toFixed(2), bold: true, alignment: 'right'}]);
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
					var_textoGarantias.push({ text: ',  tambi??n conocido (a) indistintamente con el (los) nombre (s) de '});
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
					var_textoGarantias.push({ text: ',  tambi??n conocido (a) indistintamente con el (los) nombre (s) de '});
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

var logoConsol = 'data:image/jpeg;base64,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8FHgTihT5FDotWQQQKterRuSjxJxR3DxQQLWlft4q8ndjN8FJtG6mUIY/wB2KvMmaUPQ9tpBG3wwv3mrD0ND1QQkrdo9DZWtaBjm8BC9v60qxXiTDrajNkhHsXqy1Hpuv/uQxpelWK/BybTlHGcHq2Wjo2SktCHft7VYr0gSvavYr0KZ4mMLZjVSPoNPlHC83/A8l96sV6JtpQle/AqjG270aWYnXI0vwVYr1Y0o+MJ3s7Ud52oTveWi2I+z4EeyJ8VWK/ImVDdb89WK/wAyrFf5lWGcP5iNzz0nSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpR0o6UdKOlHSjpQkVf4IOop/M2222222222222zDh/2Yf/EACsQAQACAAQEBgMBAQEBAAAAAAEAESExQWEQUXGBIJGhscHwMEDR4fFQYP/aAAgBAAABPxCYcZvSKW1tly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXEbVSp83FYukuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cueq4rH0ly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1PFYuhLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLnquL8oly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLlz1fFeUS5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly/AS8gly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLl+AH5RLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLmPiH5BLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXL8GLyiXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuXLly5cuX4EflEuXLly5cuXLly5cuXLly5cuXLgdg7BOZvJmeuDUMy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';
