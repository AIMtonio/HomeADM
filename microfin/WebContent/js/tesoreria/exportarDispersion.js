var folioOperacion=0;
var institucionID=0;
var tipoTransaccion=0;
var archivo="";
var dispersaSantander ="N";

$(document).ready(function(){

	var 	catTipoAccion	=	{
	'exporta'	: 	1
	};

	var 	catTipoConsultaDispersion	=	{
		'conDisperAut'		: 	5,
		'dispTransOrderPag'		: 	8
	};

	var 	catTipoConsultaInstituciones	=	{
		'principal'		: 	1,
		'foranea'		: 	2
	};
	
	var 	catTipoConsultaCtaAhorro	=	{
		'saldoDisponible'	: 	9
	};

	var 	catTipoConsultaCtaTesoreria 	=	{
		'saldo' 	: 	10
	};
	$("#archOrdenPago").hide();
	$("#archTransfer").hide();
	$("#enlaceExp").show();
	const 	DispersionAut 	= 	'A';
	consultaDispersaSantander();
	deshabilitaBoton('exportarArchivo', 'submit');
	deshabilitaBoton('exportarArchivoOrdenPago', 'submit');
	deshabilitaBoton('exportarArchivoTransfer', 'submit');
	$('#enlaceExp').removeAttr("href");

	$('#folioOperacion').focus();
	
	$('#exportarArchivo').click(function(event) {
		folioOperacion = $('#folioOperacion').val();
		institucionID=$('#institucionID').val();
		if(validaExisteLayout(parseInt(institucionID))==false){
			return false;
		}else{
			$('#enlaceExp').attr('href','exportaDispercionTxt.htm?folioOperacion='+folioOperacion+'&institucionID='+institucionID);
			$('#folioOperacion').val('');
			$('#folioOperacion').focus();
		}
	});
	$('#exportarArchivoOrdenPago').click(function(event) {
		folioOperacion = $('#folioOperacion').val();
		institucionID=$('#institucionID').val();
		tipoTransaccion=1;
		archivo="DispSantanderOdenPag";
		if(validaExisteLayout(parseInt(institucionID))==false){
			return false;
		}else{
			$('#archOrdenPago').attr('href','exportaDispercionTxt.htm?folioOperacion='+folioOperacion+
																'&institucionID='+institucionID+
																'&tipoTransaccion='+tipoTransaccion+
																'&nombreArchivo='+archivo);

			$('#folioOperacion').val('');
			$('#folioOperacion').focus();
		}
	});

	$('#exportarArchivoTransfer').click(function(event) {
		folioOperacion = $('#folioOperacion').val();
		institucionID=$('#institucionID').val();
		tipoTransaccion=2;
		archivo="DispSantanderTranfer";
		if(validaExisteLayout(parseInt(institucionID))==false){
			return false;
		}else{
			$('#archTransfer').attr('href','exportaDispercionTxt.htm?folioOperacion='+folioOperacion+
																 '&institucionID='+institucionID+
																 '&tipoTransaccion='+tipoTransaccion+
																 '&nombreArchivo='+archivo);

			var paginaArchOtros ='generaArchText.htm?nombreArch='+"DispOtrosSantanderTranfer"+
																 '&tipoArchivo='+"2"+
																 '&institucionID='+institucionID+
																 '&folioOperacion='+folioOperacion+
																 '&extension='+".txt";
			window.open(paginaArchOtros,'_blank');
			$('#folioOperacion').val('');
			$('#folioOperacion').focus();
		}
	});

	$('#folioOperacion').bind('keyup',function(e){
		var camposLista = new Array();
		var tipoLista='2';
		var parametrosLista = new Array();
		camposLista[0]	=	"institucionID";
		parametrosLista[0]	=	$('#folioOperacion').val();
		listaAlfanumerica('folioOperacion','0',tipoLista,camposLista,parametrosLista,'dispersionListaVista.htm');
		
	});

	$('#folioOperacion').blur(function(){
		
			if($('#folioOperacion').val()	!=	""	&&	$('#folioOperacion').val()	>0	&&	!isNaN($('#folioOperacion').val())){
				validaDispersionAut(this.id);
			}
			else{
				limpiaCampos();				
			}
		
	});


	/*
	Valida si el numero de dispersion introducido  es una Dispersion Autorizada
	para asi habilitar los controles correspondientes.
	*/
	function	validaDispersionAut(idControl){
		setTimeout("$('#cajaLista').hide();",200);
		var 	jqFolio		=	eval("'#"+idControl+"'");
		var 	valFolio	=	$(jqFolio).val();

		var 	DispersionBeanCta	=	{
			'folioOperacion'	: 	$('#folioOperacion').val()
		};

		operDispersionServicio.consulta(catTipoConsultaDispersion.conDisperAut,DispersionBeanCta,function(dispersiones){
			if(dispersiones 	!=	null){
				if(dispersiones.estatusEnc 	== 	DispersionAut || dispersiones.estatusEnc 	== 	'E'){
					var fechaDeOp	=	dispersiones.fechaOperacion;
					$('#fechaActual').val(fechaDeOp.substr(0,10));
					$('#institucionID').val(dispersiones.institucionID);
					$('#cuentaAhorro').val(dispersiones.cuentaAhorro);
							
					consultaInstitucion('institucionID');
					habilitaBoton('exportarArchivo', 'submit');
				}
				else{
					limpiaCampos();
					$('#folioOperacion').val("");
					mensajeSis('La Dispersión no se Encuentra Autorizada.');
				}
			}else{
				limpiaCampos();
				$('#folioOperacion').val("");
				mensajeSis('La Dispersión no Existe.');
			}
		});
	}

	/*
	Funcion que consulta y rellena los campos relacionados con
	una Institucion	si es que existe.
	*/
	function	consultaInstitucion(idControl){
		setTimeout("$('#cajaLista').hide();",200);
		var jqInstitucion = eval("'#" + idControl + "'");
		var numInstitucion = $(jqInstitucion).val();

		var 	InstitucionBeanCon	=	{
			'institucionID'	: 	numInstitucion
		};
		//VALIDACION SI ES SANTANDER
		if(numInstitucion==28 && dispersaSantander=="S"){
			$("#archOrdenPago").show();
			$("#archTransfer").show();
			$("#enlaceExp").hide();
			validaDispersionSan();
		}
		else{
			$("#archOrdenPago").hide();
			$("#archTransfer").hide();
			$("#enlaceExp").show();
		}

		if(numInstitucion	!=	''	&&	!isNaN(numInstitucion)	&&	numInstitucion	>	0){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitucionBeanCon,function(institucion){
				if(institucion 	!=	null){
					$('#nombreInstitucion').val(institucion.nombre);
					validaCuentaAhorro();	
				}

			});
			

		}

	}


	/*
	Valida un numero de Cuenta de Ahorro, de ser Valida rellena los campos
	correspondientes.
	*/
	function validaCuentaAhorro(){
		setTimeout("$('cajaLista').hide();",200);
		var numInstitucion 	= 	$('#institucionID').val();
		var numCuenta	= 	$('#cuentaAhorro').val();

		var DispersionBeanCta	=	{
			'institucionID'	: 	numInstitucion,
			'numCtaInstit'	: 	numCuenta
		};
		if(numCuenta	!=	''	&&	numCuenta	>0	&&	!isNaN(numCuenta)){
			operDispersionServicio.consulta(catTipoConsultaCtaAhorro.saldoDisponible, DispersionBeanCta, function(cuenta){
				if(cuenta 	!=	null){
					$('#cuentaAhorro').val(cuenta.numCtaInstit);
					$('#numCtaInstit').val(cuenta.numCtaInstit);
					$('#nombreSucurs').val(cuenta.nombreCuentaInst);
					consultaSaldoCuentaTesoreria(cuenta.numCtaInstit,$('#institucionID').val());									
				}
				else{
					limpiaCampos();
					mensajeSis('No Existe el Número de Cuenta.');
				}
			});
		}
		else{
			limpiaCampos();
			mensajeSis('Número de Cuenta Invalido.');
		}
	}


	/*
	Funcion para la consulta de Saldo de un Cuenta de Tesoreria
	*/
	function consultaSaldoCuentaTesoreria(numCta, institucion){
		var cuentaTesoreria = {
				'institucionID': institucion,
				'numCtaInstit':numCta
		};	

		cuentaNostroServicio.consulta(catTipoConsultaCtaTesoreria.saldo, cuentaTesoreria, function(saldoCtaTesoreria){
			if(saldoCtaTesoreria!=null){
				$('#saldo').val(saldoCtaTesoreria.saldo);
			}
			else{
				limpiaCampos();
				mensajeSis('No Existe Saldo en la Cuenta '+numCta);
				
			}
		});   
	}


	/*
	Funcion para limpiar los campos que contienen datos de la Dispersion
	asi como tambien desabilita el boton de ExportarArchivo y se remueve su href
	para que no se genere un archivo vacio cuando el boton este Desabilitado.
	*/
	function	limpiaCampos(){
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');		
		$('#cuentaAhorro').val('');
		$('#numCtaInstit').val('');	
		$('#nombreSucurs').val('');
		$('#saldo').val('');
		$('#fechaActual').val('');
		deshabilitaBoton('exportarArchivo','submit');
		$('#enlaceExp').removeAttr("href");
		$('#folioOperacion').focus();
		deshabilitaBoton('exportarArchivoOrdenPago', 'submit');
		deshabilitaBoton('exportarArchivoTransfer', 'submit');
		$("#archOrdenPago").hide();
		$("#archTransfer").hide();
		$("#enlaceExp").show();
	}



	function validaExisteLayout(institucion){
		/* Esta funcion se actualizara conforme a los layoutys que hayamos creado en
		 * tesoreria.reporte.DispercionRepControlador si agregamos un nuevo layout Editamos a funcion
		 * comentamos  mensaje+="institucion"; y retorno = true
		 * 
		 * */
		var mensaje="No existe el formato para:";
		var retorno= true;
		switch(institucion){
		case 1: mensaje+=" Nafin" ;				retorno=false; break;		
		case 2: mensaje+="Bancomext";			retorno=false; break;
		case 3: mensaje+="Banobras"	;			retorno=false; break;	
		case 4: mensaje+="SHF"	;				retorno=false; break;
		case 5: mensaje+="Banjercito"	;		retorno=false; break;	
		case 6: mensaje+="Bansefi"	;			retorno=false; break;
		case 7: mensaje+="ABC Capital"	;		retorno=false; break;
		case 8: mensaje+="American	Express";	retorno=false; break;
		case 9: mensaje+="Banamex"	;			retorno=false; break;
		case 10:mensaje+="Afirme";				retorno=false; break;
		case 11:/*mensaje+="Mifel"	;*/			retorno=true;  break;	// ya existe el layout en controlador
		case 12:mensaje+="Actinver";			retorno=false; break;	
		case 13:mensaje+="Famsa"	;			retorno=false; break;	
		case 14:mensaje+="Autofin"	;			retorno=false; break;	
		case 15:mensaje+="Banco Azteca";		retorno=false; break;
		case 16:mensaje+="Compartamos"	;		retorno=false; break;	
		case 17:mensaje+="Credit Suisse"	;	retorno=false; break;
		case 18:mensaje+="Banco del Bajio";		retorno=false; break;
		case 19:mensaje+="Banco Facil";			retorno=false; break;
		case 20:mensaje+="Inbursa"	;			retorno=false; break;
		case 21:mensaje+="Interacciones";		retorno=false; break;	
		case 22:mensaje+="Invex"	;			retorno=false; break;
		case 23:mensaje+="J.P. Morgan"	;		retorno=false; break;
		case 24:/*mensaje+="Banorte"	;*/		retorno=true;  break;// ya existe el layout en controlador	
		case 25:mensaje+="Monex"	;			retorno=false; break;
		case 26:mensaje+="Multiva"	;			retorno=false; break;	
		case 27:mensaje+="Banregio";			retorno=false; break;	
		case 28:/*mensaje+="Santander";*/		retorno=true;  break;// ya existe el layout en controlador		
		case 29:mensaje+="Ve por Mas" 	;		retorno=false; break;
		case 30:mensaje+="Wall Mart";			retorno=false; break;
		case 31:mensaje+="Coppel"	;			retorno=false; break;
		case 32:mensaje+="Merril Lynch";		retorno=false; break;
		case 33:mensaje+="New	York"	;		retorno=false; break;
		case 34:mensaje+="Tokyo Mitsubishi";	retorno=false; break;
		case 35:mensaje+="BanSi"	;			retorno=false; break;
		case 36:mensaje+="Barclays";			retorno=false; break;	
		case 37:/*mensaje+="Bancomer	";	*/	retorno=true; break;
		case 38:mensaje+="CI Banco";			retorno=false; break;
		case 39:mensaje+="Deutsche Bank";		retorno=false; break;
		case 40:mensaje+="HSBC	"	;			retorno=false; break;
		case 41:mensaje+="ING"	;				retorno=false; break;
		case 42:mensaje+="Inter Banco"	;		retorno=false; break;
		case 43:mensaje+="IXE"	;				retorno=false; break;
		case 44:mensaje+="Scotiabank"	;		retorno=false; break;	
		case 45:mensaje+="Royal Scotland"	;	retorno=false; break;
		case 46:mensaje+="UBS	Bank";			retorno=false; break;
		case 47:mensaje+="Volkswagen"	;		retorno=false; break;	
		case 48:mensaje+="FinSur SOFIPO";		retorno=false; break;
		case 49:mensaje+="FinSur SOFOM";		retorno=false; break;	
		case 50:mensaje+="FIRA"	;				retorno=false; break;	
		case 51:mensaje+="INVERLAT";			retorno=false; break;	
		case 52:mensaje+="AMIGO";				retorno=false; break;	
		case 53:mensaje+="Autofin"	;			retorno=false; break;	
		case 54:mensaje+="Bcext"	;			retorno=false; break;	
		case 55:mensaje+="Banco"	;			retorno=false; break;	
		case 56:mensaje+="Deuno"	;			retorno=false; break;	
		case 57:mensaje+="Balza"	;			retorno=false; break;	
		case 58:mensaje+="Prude"	;			retorno=false; break;	
		case 59:mensaje+="Regio"	;			retorno=false; break;	
		case 60:mensaje+="Financier Rural"	;	retorno=false; break;	

		}

		if(retorno==false){
			mensajeSis(mensaje);
		}
		return retorno;
	}


	//Metodo Para consultar si se maneja dispersion SANTANDER
	function consultaDispersaSantander(){
		var tipoConsulta = 43;
		var bean = {
				'empresaID'     : 1
			};

		paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
				if (parametro != null){
					dispersaSantander = parametro.valorParametro;
				}else {
					dispersaSantander = 'N';
				}

		}});
	}

	function	validaDispersionSan(){
		var 	DispersionBeanCta	=	{
			'folioOperacion'	: 	$('#folioOperacion').val()
		};

		operDispersionServicio.consulta(catTipoConsultaDispersion.dispTransOrderPag,DispersionBeanCta,function(dispersiones){
			if(dispersiones !=null){
				if(dispersiones.contDispOrdpag>0){
					habilitaBoton('exportarArchivoOrdenPago', 'submit');
				}else{
					deshabilitaBoton('exportarArchivoOrdenPago', 'submit');
				}
				if(dispersiones.contDispTrans!="0"){
					habilitaBoton('exportarArchivoTransfer', 'submit');
				}else{
					deshabilitaBoton('exportarArchivoTransfer', 'submit');
				}
				
			}
		});
	}
});
