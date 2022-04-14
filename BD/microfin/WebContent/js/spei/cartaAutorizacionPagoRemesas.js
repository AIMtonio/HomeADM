pdfMake.fonts = {
	arial: {
		normal: 'arial.ttf',
		bold: 'arialbd.ttf',
		italics: 'ariali.ttf',
		bolditalics: 'arialbi.ttf'
	}
};

var tipoPagoSPEI = 1;
var remesas = [];
var montoTotalLetras = '';

function generarCartaAutorizacion(tipoCarta, tituloCarta, lugarSucursal, fechaEmision, nombreEmpresa, sucursal, nombreCliente, razonSocial, clienteID, tipoCuenta, cuentaAhoID, montoTotal, speiRemesas, usuario) {

	if (tipoCarta == tipoPagoSPEI) {

		pagoRemesaSPEIServicio.lista(4, { 'speiRemID': speiRemesas }, {
			async: false, callback: function (lista) {

				remesas = lista;
				montoTotal = lista[0]?.sumaTotalLetras || '0.00';
			}
		});
	} else {
		remesas = speiRemesas;
	}

	var monto = +(montoTotal.replace(/[,]/g, ''));
	var numLetras = convertirNumeroALetras(monto, false);
	montoTotalLetras = '$ ' + montoTotal + ' (' + numLetras + ' 00/100 M.N.)';

	var documento = {
		pageMargins: [45, 60, 45, 60],
		content: [
			{
				columns: [
					{
						text: 'CARTA DE AUTORIZACIÓN ' + tituloCarta,
						style: 'header'
					}
				],
				fontSize: 12,
				bold: true
			}, {
				text: lugarSucursal + ', ' + fechaEmision,
				alignment: 'right',
				margin: [0, 40, 0, 40]

			}, {
				text: [
					nombreEmpresa,
					'\n',
					'SUCURSAL ', sucursal
				],
				alignment: 'left',
				margin: [0, 0, 0, 15],
				bold: true
			}, {
				text: 'PRESENTE',
				alignment: 'left',
				margin: [0, 0, 0, 15],
				bold: true
			}, {
				text: [
					{
						text: nombreCliente + ',',
						bold: true
					},
					' REPRESENTANTE LEGAL DE ',
					{ text: razonSocial, bold: true },
					' CON NÚMERO DE CLIENTE ',
					{ text: clienteID, bold: true },
					' AUTORIZO AL GERENTE DE ', nombreEmpresa, ', SUCURSAL ', sucursal,
					', PARA QUE REALICE LAS TRANSFERENCIAS ELECTRÓNICAS Y/O TRANSFERENCIAS ENTRE CUENTAS CON CARGO A MI CUENTA ',
					{ text: tipoCuenta, bold: true },
					' NÚMERO ',
					{ text: cuentaAhoID, bold: true },
					{ text: ' POR UNA CANTIDAD TOTAL DE ', bold: true },
					{ text: montoTotalLetras, bold: true},
					' A LAS CUENTAS DE LOS BENEFICIARIOS CUYOS DATOS SE DESCRIBEN A CONTINUACIÓN:'
				]
			},{
				table: {
					body: crearTabla(remesas)
				},
				fontSize: 8,
				alignment: 'center',
				margin: [0, 15, 0, 0]
			}, {
				columns: [
					{
						width: '50%',
						alignment: 'center',
						bold: true,
						text: 'AUTORIZA'
					},{
						width: '50%',
						alignment: 'center',
						bold: true,
						text: 'REALIZA'
					}
				],
				margin: [0, 30]
			}, {
				columns: [
					{
						width: '50%',
						alignment: 'center',
						text: usuario
					},{
						width: '50%',
						alignment: 'center',
						text: 'SUCURSAL ' + sucursal
					}
				]
			}
		],
		footer: function () {
			return [
				{
					text: [
						{
							text: 'NOTA: ',
							bold: true
						},
						'FAVOR DE REVISAR QUE LOS DATOS PROPORCIONADOS SEAN CORRECTOS YA QUE ',
						{
							text: nombreEmpresa,
							decoration: 'underline'
						},
						' NO SE HACE RESPONSABLE SI LA INFORMACIÓN ANOTADA ES INCORRECTA, ASÍ MISMO TAMPOCO SE RESPONSABILIZA SI PRODUCTO DE ESOS ERRORES SE GENERA ALGÚN CARGO PARA EL CLIENTE.'

					],
					alignment: 'justify',
					margin: [45, -40, 45, 0]
				}
			]
		},
		styles: {
			header: {
				alignment: 'center'
			}
		},
		defaultStyle: {
			font: 'arial',
			fontSize: 10,
			alignment: 'justify'
		}
	}

	pdfMake.createPdf(documento).open();
}

function crearTabla(remesas) {

	var tablaRemesas = [
		[{ text: 'CTA. CLABE', bold: true}, { text: 'BANCO', bold: true}, { text: 'SUCURSAL O PLAZA', bold: true},
		{ text: 'FECHA Y HORA', bold: true}, { text: 'MONTO', bold: true}, { text: 'IVA', bold: true},
		{ text: 'COMISIÓN', bold: true}, { text: 'CONCEPTO DE CARGO', bold: true}, { text: 'TOTAL DEL CARGO EFECTUADO', bold: true}]
	];

	for (var remesa of remesas) {

		tablaRemesas.push([
			remesa.cuentaClabe || '',
			remesa.banco || '',
			remesa.sucursal || '',
			remesa.fechaHora || '',
			remesa.monto || '',
			remesa.ivaPorPagar || '',
			remesa.comision || '',
			remesa.conceptoPago || '',
			remesa.totalCargo || ''
		]);
	}

	return tablaRemesas;
}

var unidadesObj = { 1: 'UN', 2: 'DOS', 3: 'TRES', 4: 'CUATRO', 5: 'CINCO', 6: 'SEIS', 7: 'SIETE', 8: 'OCHO', 9: 'NUEVE' };
var decimObj = { 0: 'DIEZ', 1: 'ONCE', 2: 'DOCE', 3: 'TRECE', 4: 'CATORCE', 5: 'QUINCE' };
var decenasObj = { 3: 'TREINTA', 4: 'CUARENTA', 5: 'CINCUENTA', 6: 'SESENTA', 7: 'SETENTA', 8: 'OCHENTA', 9: 'NOVENTA' };
var centenasObj = {
	2: 'DOSCIENTOS ', 3: 'TRESCIENTOS ', 4: 'CUATROCIENTOS ', 5: 'QUINIENTOS ',
	6: 'SEISCIENTOS ', 7: 'SETECIENTOS ', 8: 'OCHOCIENTOS ', 9: 'NOVECIENTOS '
};

function convertirUnidades(num) {

	var unidad = unidadesObj[num] || '';

	return unidad;
}

function convertirDecenas(num) {

	var decena = Math.floor(num / 10);
	var unidad = num - (decena * 10);
	var decenaConvertida = '';

	switch (decena) {
		case 0:
			decenaConvertida = convertirUnidades(unidad);
			break;
		case 1:
			decenaConvertida = decimObj[unidad] || 'DIECI' + convertirUnidades(unidad);
			break;
		case 2:
			decenaConvertida = (unidad != 0) ? 'VEINTI' +  convertirUnidades(unidad): 'VEINTE';
			break;
		default:
			decenaConvertida = convertirDecenasY(decenasObj[decena], unidad);
			break;
	}

	return decenaConvertida;
}

function convertirDecenasY(strSin, numUnidades) {

	if (numUnidades > 0) {
		strSin = strSin + ' Y ' + convertirUnidades(numUnidades)
	}

	return strSin;
}

function convertirCentenas(num) {

	var centenas = Math.floor(num / 100);
	var decenas = num - (centenas * 100);
	var centenaConvertida = '';

	if (centenas > 0 && centenas < 10) {
		switch (centenas) {
			case 1:
				centenaConvertida = (decenas > 0) ? 'CIENTO ' + convertirDecenas(decenas) : 'CIEN';
				break;
			default:
				centenaConvertida = centenasObj[centenas] + convertirDecenas(decenas);
				break;
		}
	} else {
		centenaConvertida = convertirDecenas(decenas);
	}

	return centenaConvertida;
}

function convertirSeccion(num, divisor, strSingular, strPlural) {

	var cientos = Math.floor(num / divisor);
	var resto = num - (cientos * divisor);
	var convertido = '';

	if (cientos > 0) {
		convertido = (cientos > 1) ? convertirCentenas(cientos) + ' ' + strPlural : strSingular;
	}

	if (resto > 0) {
		convertido += '';
	}

	return convertido;
}

function convertirMiles(num) {

	var divisor = 1000;
	var cientos = Math.floor(num / divisor);
	var resto = num - (cientos * divisor);

	var strMiles = convertirSeccion(num, divisor, 'MIL', 'MIL');
	var strCentenas = convertirCentenas(resto);

	return (strMiles == '') ? strCentenas : strMiles + ' ' + strCentenas;
}

function convertirMillones(num) {

	var divisor = 1000000;
	var cientos = Math.floor(num / divisor);
	var resto = num - (cientos * divisor);

	var strMillones = convertirSeccion(num, divisor, 'UN MILLON', 'MILLONES');
	var strMiles = convertirMiles(resto);

	return (strMillones == '') ? strMiles : strMillones + ' ' + strMiles;
}

function convertirNumeroALetras(num, centavos) {

	var data = {
		enteros: Math.floor(num),
		centavos: (((Math.round(num * 100)) - (Math.floor(num) * 100))),
		letrasCentavos: '',
	};
	var numeroConvertido = '';

	if (centavos == undefined || centavos == false) {
		data.letrasMonedaPlural = 'PESOS';
		data.letrasMonedaSingular = 'PESO';
	} else {
		data.letrasMonedaPlural = 'CENTAVOS';
		data.letrasMonedaSingular = 'CENTAVO';
	}

	if (data.centavos > 0 && centavos != false) {
		data.letrasCentavos = 'CON ' + convertirNumeroALetras(data.centavos, true);
	}

	switch (data.enteros) {
		case 0:
			numeroConvertido = 'CERO ' + data.letrasMonedaPlural + ' ' + data.letrasCentavos;
			break;
		case 1:
			numeroConvertido = convertirMillones(data.enteros) + ' ' + data.letrasMonedaSingular + ' ' + data.letrasCentavos;
			break;
		default:
			numeroConvertido = convertirMillones(data.enteros) + ' ' + data.letrasMonedaPlural + ' ' + data.letrasCentavos;
			break;
	}

	return numeroConvertido;
}