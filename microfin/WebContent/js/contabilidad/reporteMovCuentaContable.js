$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();
	$('#nombreusuario').val(parametros.claveUsuario);
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaEmision').val(parametroBean.fechaSucursal);
	$('#primerRango').val(0); // rango tipo de instrumento
	$('#segundoRango').val(0); // rango tipo deinstrumento
	$('#primerCentroCostos').val(0);
	$('#segundoCentroCostos').val(0);
	$('#descripcionCenCosIni').val('TODOS');	
	$('#descripcionCenCosFin').val('TODOS');
	deshabilitaControl('primerRango');
	deshabilitaControl('segundoRango');
	$('#fechaIni').focus();

	// Definicion de Constantes y Enums
	var catTipoListaMoneda = {
			'principal': 3
	};

	var catTipoListaSucursal = {
			'combo': 2
	};
		
	var catTipoListaInversion = {
			'principal': 1
	};	
	var catStatusInversion = {
	  		'alta':		'A'
	};
	var catTipoConsultaCentro = { 
		  	'principal'	: 1,
		  	'foranea'	: 2
	};
	var tipoInstrumento = 0;
	var tipoInstrCliente = 0;
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#fechaIni').val(parametros.fechaAplicacion); 	
	$('#fechaFin').val(parametros.fechaAplicacion);
	consultaTipoInstrumentos();

	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#primerRango').blur(function(){
		validaPrimerRango(this.id);	
		ponerCerosRangosIntrumentos();
	});
	$('#segundoRango').blur(function(){
		validaSegundoRango(this.id);	
		ponerCerosRangosIntrumentos();
	});

	$('#primerCentroCostos').bind('keyup',function(e){
		lista('primerCentroCostos', '2', '1', 'descripcion', $('#primerCentroCostos').val(), 'listaCentroCostos.htm');
	});
	$('#segundoCentroCostos').bind('keyup',function(e){
		lista('segundoCentroCostos','2','1','descripcion', $('#segundoCentroCostos').val(),'listaCentroCostos.htm');
	});

	$('#primerCentroCostos').blur(function(){		
		valPrimerCentroCosto(this.id);
		consultaCentroCostosIni(this.id);
	});
	$('#segundoCentroCostos').blur(function(){
		validaSegudoCentro(this.id);
		consultaCentroCostosFin(this.id);
	});
	
	$('#primerRango').blur(function(){
		ocultaLista();
	});
	$('#segundoRango').blur(function(){
		ocultaLista();
	});	
	
	$('#cuentaCompleta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuentaCompleta').val();
			listaAlfanumerica('cuentaCompleta', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	$('#cuentaCompletaFin').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuentaCompletaFin').val();
			listaAlfanumerica('cuentaCompletaFin', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	$('#cuentaCompleta').blur(function() {
		if(!isNaN($('#cuentaCompleta').val())){
			maestroCuentasDescripcion(this.id,'desCuentaCompleta');
		}
	});

	$('#cuentaCompletaFin').blur(function() {
		if(!isNaN($('#cuentaCompletaFin').val())){
			maestroCuentasDescripcion(this.id,'desCuentaCompletaF');
		}
	});

	$('#pdf').click(function() {	
		$('#excel').attr("checked",false);
	});
	$('#excel').click(function() {	
		$('#pdf').attr("checked",false);
	});

	$('#generar').click(function(){			
		if (validaParametrosReporte() == '0'){
			validaCuenta();
		}
	});

	$('#fechaIni').change(function(){
		var Xfecha= $('#fechaIni').val();
		if(esFechaValida(Xfecha,1)){
			if(Xfecha=='')$('#fechaIni').val(parametroBean.fechaSucursal);
			var Yfecha= parametros.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				alert("La Fecha Inicial es Mayor a la Fecha del Sistema")	;
				$('#fechaIni').val(parametroBean.fechaSucursal);
				regresarFoco('fechaIni');
			}else{
				if(!esTab){
					regresarFoco('fechaIni');
				}
			}
		}else{
			$('#fechaIni').val(parametroBean.fechaSucursal);
			regresarFoco('fechaIni');
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaIni').val();
		var Yfecha= $('#fechaFin').val();
		var Zfecha= parametroBean.fechaSucursal;
		if(esFechaValida(Yfecha,0)){
			if(Yfecha=='')$('#fechaFin').val($('#fechaIni').val());
			if(mayor(Yfecha,Zfecha)){
				alert("La Fecha Final es Mayor a la Fecha del Sistema");				
				regresarFoco('fechaFin');
				$('#fechaFin').val($('#fechaIni').val());
			}else{
				if(mayor(Xfecha, Yfecha)){
					alert("La Fecha Inicial es Mayor a la Fecha de Final");				
					regresarFoco('fechaFin');
					$('#fechaFin').val($('#fechaIni').val());
				}else{
					if(!esTab){
						regresarFoco('fechaFin');	
					}
				}
			}			
		}else{
			$('#fechaFin').val($('#fechaIni').val());
			regresarFoco('fechaFin');
		}
	});
	
	$('#tipoInstrumentoID').change(function(){
		validaTipoInstrumento(this.id);
	});
	
	$('#primerRango').blur(function(){
		if( tipoInstrumento == tipoInstrCliente){
		$('#segundoRango').val($('#primerRango').val());
		}
		});
	$('#primerCentroCostos').blur(function(){
		ponerCeros();
	});
	$('#segundoCentroCostos').blur(function(){
		ponerCeros();
	});
	$('#primerRango').blur(function(){
		ponerCerosRangosIntrumentos();
	});
	$('#segundoRango').blur(function(){
		ponerCerosRangosIntrumentos();
	});

	/*	----------- Validaciones de la Forma -------------------------------------*/

	$('#formaGenerica').validate({	
		rules: {
			cuentaCompleta: {
				required: true,				
				minlength: 1

			},
			fechaIni: {
				date: true

			},
			fechaFin: {
				date: true

			},
			cuentaCompletaFin: {
				required: true,				
				minlength: 1
			}
		},		
		messages: {
			cuentaCompleta: {
				required: 'Especificar No. de Cuenta Contable.',
				minlength: 'Mínimo 1 Número.'

			},
			fechaIni: {
				date: 'Fecha Incorrecta.'

			},
			fechaFin: {
				date: 'Fecha Incorrecta.'

			},
			cuentaCompletaFin: {
				required: 'Especificar No. de Cuenta Contable.',				
				minlength: 'Mínimo 1 Número.'

			}

		}		
	});

	function validaCuenta(){
		var cuenta = $('#cuentaCompleta').val();
		var cuentaFin =$('#cuentaCompletaFin').val();
		var desCtaFin=	$('#desCuentaCompletaF').val();
		var desCta =$('#desCuentaCompleta').val();
		var nombreusuario = 	$('#nombreusuario').val();
		var nombreInstitucion = $('#nombreInstitucion').val();
		var fechaInicio=$('#fechaIni').val();
		var fechaFin =$('#fechaFin').val();
		var fechaEmision = $('#fechaEmision').val();
		var primerRango = $('#primerRango').val();
		var segundoRango = $('#segundoRango').val();
		var primerCentroC = $('#primerCentroCostos').val();
		var segundoCentroC = $('#segundoCentroCostos').val();
		var tipoInstrumentoID = $('#tipoInstrumentoID').val();
		var tipoReporte = 0;
		var descTipoInstrumento = $("#tipoInstrumentoID option:selected").val();
		if(fechaFin<fechaInicio){
			alert("La Fecha Final No Debe ser Menor que la Fecha Inicial");
			$('#cuentaCompleta').focus();
		}
		else{
			if(cuenta == ''){
				alert("Especificar No. de Cuenta Contable Inicial");
				$('#cuentaCompleta').focus();
			} else if(cuentaFin==''){
				alert("Especificar No. de Cuenta Contable Final");
				$('#cuentaCompletaFin').focus();
			} else{
				if($('#excel').attr("checked")==false && $('#pdf').attr("checked")==false){
					alert("No ha Seleccionado Ninguna Opción para la Presentación del Reporte");
				}
				else{
					
					if($('#tipoInstrumentoID').val() == ''){
					tipoInstrumentoID = '0';
				    }
					if(descTipoInstrumento=='0'){
						descTipoInstrumento='INDISTINTO';
					}
					else{
						descTipoInstrumento= $("#tipoInstrumentoID option:selected").html();
					}		
					
					if($('#excel').is(':checked')){
						tipoReporte = 3;

					}
					if($('#pdf').is(':checked')){
						tipoReporte = 2;
					}
					if(cuenta>cuentaFin){
						alert("La Cuenta Final Debe ser Mayor a la Inicial para Generar el Reporte");
						$('#cuentaCompletaFin').focus();
					}

					else{

						var pagina ='MovCuentaContable.htm?cuentaCompleta='+cuenta+'&desCuentaCompleta='+desCta
						+'&cuentaCompletaFin='+cuentaFin+'&desCuentaCompletaF='+desCtaFin						
						+'&fechaIni='+fechaInicio+'&fechaFin='+fechaFin
						+'&nombreusuario='+nombreusuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision
						+'&primerRango='+primerRango+'&segundoRango='+segundoRango+'&primerCentroCostos='+primerCentroC+'&segundoCentroCostos='
						+segundoCentroC+'&tipoInstrumentoID='+tipoInstrumentoID+'&descTipoInstrumento='+descTipoInstrumento;
						
						window.open(pagina+'&tipoReporte='+tipoReporte,'_blank');
					}
				}
			}
		}
	}
	function validaParametrosReporte(){
		var error = 0;
		if($('#primerRango').asNumber() >0 && $('#segundoRango').asNumber() <=0){
			alert("El Segundo Rango se Encuentra Vacío");
			$('#segundoRango').focus(); 
			error = 1;
		}else{
			if($('#primerRango').asNumber() <= 0 && $('#segundoRango').asNumber() >0){
				alert("El Primer Rango se Encuentra Vacío");
				$('#primerRango').focus(); 
				error = 1;
			}else{
				if($('#primerCentroCostos').asNumber() > 0 && $('#segundoCentroCostos').asNumber() <= 0){
					alert("El Centro de Costos Final se Encuentra Vacío");
					$('#segundoCentroCostos').focus(); 
					error = 1;
				}else{
					if($('#primerCentroCostos').asNumber() <= 0 && $('#segundoCentroCostos').asNumber() > 0){
						alert("El Centro de Costos Inicial se Encuentra Vacío");
						$('#primerCentroCostos').focus(); 
						error = 1;
					}
				}
			}
		}
			if(($('#primerRango').asNumber()>$('#segundoRango').asNumber())&& $('#segundoRango').asNumber()!=0){
				alert("El Primer Rango No Puede ser Mayor al Segundo");
				$('#segundoRango').focus();
				error=1;
			}
			if(error==0){
				if($('#primerCentroCostos').asNumber()>$('#segundoCentroCostos').asNumber()){
					alert("El Primer Centro de Costos No Puede ser Mayor al Segundo");
					$('#segundoCentroCostos').focus();
					error=1;
				}
			}
			
			if(isNaN($('#primerRango').val())){				
				$('#primerRango').val('0');
				$('#primerRango').focus();				
			}if(isNaN($('#segundoRango').val())){
				$('#segundoRango').val('0');
				$('#segundoRango').focus();				
			}if(isNaN($('#primerCentroCostos').val())){
				$('#primerCentroCostos').val('0');
				$('#primerCentroCostos').focus();				
			}if(isNaN($('#segundoCentroCostos').val())){
				$('#segundoCentroCostos').val('0');
				$('#segundoCentroCostos').focus();				
			}
			
			if(isNaN($('#cuentaCompleta').val())){
				alert('La Cuenta Contable Inicial Debe Contener Números');
				$('#cuentaCompleta').val('');
				$('#cuentaCompleta').focus();
				$('#desCuentaCompleta').val('');	
				error=1;
			}else if(isNaN($('#cuentaCompletaFin').val())){
				alert('La Cuenta Contable Final Debe Contener Números');
				$('#cuentaCompletaFin').val('');
				$('#cuentaCompletaFin').focus();
				$('#desCuentaCompletaF').val('');
				error=1;				
			}
		return error;
	}
	function maestroCuentasDescripcion(idControl, idControlDes){ 		
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable =  $(jqCtaContable).val(); 
		var conForanea = 2;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
				if(ctaConta!=null){
					$('#'+idControlDes).val(ctaConta.descripcion);
				}
				else{
					alert("No Existe la Cuenta Contable");
					$('#'+idControlDes).val('');
					$(jqCtaContable).val('');
					$(jqCtaContable).focus();
				}
			}); 
		}
		if(numCtaContable != '' && isNaN(numCtaContable)){
			alert("No Existe la Cuenta Contable");
			$('#'+idControlDes).val('');
			$(jqCtaContable).val('');
			$(jqCtaContable).focus();
		}
	}

//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){
		if (fecha != undefined && fecha != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecta");
					$('#fechaIni').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaIni').focus();

				}else{
					alert("Formato de Fecha Final Incorrecta");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecta");
					$('#fechaIni').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaIni').focus();

				}else{
					alert("Formato de Fecha Final Incorrecta");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}
			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecta");
					$('#fechaIni').val(parametros.fechaAplicacion); 	
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaIni').focus();

				}else{
					alert("Formato de Fecha Final Incorrecta");
					$('#fechaFin').val(parametros.fechaAplicacion);
					$('#fechaFin').focus();
				}
				return false;
			}
			return true;
		} else {
			if(fechaIni ==1){
				alert("La Fecha Inicial se Encuentra Vacía");
				$('#fechaIni').val(parametros.fechaAplicacion); 	
				$('#fechaIni').focus();
			} else {
				alert("La Fecha Final se Encuentra Vacía");
				$('#fechaFin').val(parametros.fechaAplicacion); 	
				$('#fechaFin').focus();
			}
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	function consultaTipoInstrumentos() {
		var tipoLista  = 1;
		
		dwr.util.removeAllOptions('tipoInstrumentoID'); 
		dwr.util.addOptions('tipoInstrumentoID', {'':'INDISTINTO'});		 	
		tipoInstrumentosServicio.listaCombo(tipoLista, function(instrumento){
			dwr.util.addOptions('tipoInstrumentoID', instrumento, 'tipoInstrumentoID', 'descripcion');
		
			});
	}
	

	// funcion para validar el rango entre las listas de centro de costos
	function valPrimerCentroCosto(idControl){	
		var jqCentro = eval("'#" + idControl + "'");
		var primerCentro = $('#primerCentroCostos').asNumber();
		var segundoCentro = $('#segundoCentroCostos').asNumber();
		if(!isNaN(primerCentro)){
			if(esTab == true){
				 if(primerCentro != '' && segundoCentro != '' ){
						if(primerCentro > segundoCentro){
							alert('El Primer Valor No Puede ser Mayor que el Segundo');					
							$('#primerCentroCostos').val('');
							$('#descripcionCenCosIni').val('');
							$(jqCentro).focus();
						}
				 }
				}// es Tab
		}else{
			alert("entro a primer centro de costo");
			$('#primerCentroCostos').val('0');
			$('#descripcionCenCosIni').val('TODOS');
		}
		
	}
		
	function ocultaLista(){	
		setTimeout("$('#cajaLista').hide();", 200);		
	}

	$('#tipoInstrumentoID').change(function() {		
		$('#primerRango').val(0);
		$('#segundoRango').val(0);		
		//Tipos de Instrumentos
		var cuentasAhorro = parseFloat(2);
		var cliente = parseFloat(4);
		var empleado = parseFloat(5);
		var proveedor = parseFloat(6);
		var usuario = parseFloat(7);
		var servicio = parseFloat(8); //pago de servicios
		var chequeSBC = parseFloat(9);//cheque SBC(Banco)
		var cajeroATM = parseFloat(10);
		var creditos = parseFloat(11);
		var fondeador = parseFloat(12);
		var inversionesPlazo = parseFloat(13);
		var numeroTarjeta = parseFloat(14);
		var cajasVentanilla = parseFloat(15);
		var polizaManual	=parseFloat(17);
		var cuentaBancaria = parseFloat(19);
		var banco = parseFloat(21);
		var remesas = parseFloat(22);
		var tipoInstrumento = $('#tipoInstrumentoID option:selected').val();
		
		$('#primerRango').bind('keyup',function(e) {		
			if($('#tipoInstrumentoID').asNumber() == cuentasAhorro){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#primerRango').val();
			listaAlfanumerica('primerRango', '2', '3',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
			}
		});		
		
		$('#segundoRango').bind('keyup',function(e) {		
			if($('#tipoInstrumentoID').asNumber()  == cuentasAhorro){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#segundoRango').val();
			listaAlfanumerica('segundoRango', '2', '3',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
			}
		});
		
		$('#primerRango').bind('keyup',function(e) {
			if($('#tipoInstrumentoID').asNumber() == cliente){							
				lista('primerRango', '3', '1', 'nombreCompleto', $('#primerRango').val(), 'listaCliente.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e) { 
			if($('#tipoInstrumentoID').asNumber() ==cliente){
				lista('segundoRango', '3', '1', 'nombreCompleto', $('#segundoRango').val(), 'listaCliente.htm');
			}
		});
		
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').val()==empleado){
				if(this.value.length >= 2){ 
					var camposLista = new Array(); 
					var parametrosLista = new Array(); 
			    	camposLista[0] = "nombreCompleto";
			    	parametrosLista[0] = $('#primerRango').val();
			 listaAlfanumerica('primerRango', '1', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
			}	
		}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() == empleado){
				if(this.value.length >= 2){ 
					var camposLista = new Array(); 
					var parametrosLista = new Array(); 
			    	camposLista[0] = "nombreCompleto";
			    	parametrosLista[0] = $('#segundoRango').val();
			 listaAlfanumerica('segundoRango', '1', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
			}
			}	
		});
		
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()== proveedor){
				if(this.value.length >= 2){ 
					var camposLista = new Array();
					var parametrosLista = new Array();	 
					camposLista[0] = "apellidoPaterno"; 
					parametrosLista[0] = $('#primerRango').val();
				listaAlfanumerica('primerRango', '1', '1', camposLista, parametrosLista, 'listaProveedores.htm');
			}
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() == proveedor){
				if(this.value.length >=2){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "apellidoPaterno";
					parametrosLista[0] = $('#segundoRango').val();
				listaAlfanumerica('segundoRango', '1','1', camposLista, parametrosLista, 'listaProveedores.htm');
			}
			}
		});
		
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() ==usuario){
				lista('primerRango', '2', '1', 'nombreCompleto', $('#primerRango').val(), 'listaUsuarios.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() ==usuario){
				lista('segundoRango', '2', '1', 'nombreCompleto', $('#segundoRango').val(), 'listaUsuarios.htm');
			}
		});
		
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() ==servicio){
		var camposLista = new Array();
		var parametrosLista = new Array();		  
			camposLista[0] = "catalogoServID";
			camposLista[1] = "nombreServicio";		  
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#primerRango').val();		  
		lista('primerRango', '1', '1', camposLista,parametrosLista, 'listaCatalogoServicios.htm');
		}
		});	
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==servicio){
				var camposLista = new Array();
				var parametrosLista = new Array();		
				camposLista[0] = "catalogoServID";
				camposLista[1] = "nombreServicio"; 		
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#segundoRango').val();
			lista('segundoRango','1','1', camposLista, parametrosLista, 'listaCatalogoServicios.htm');
			}
		});
		// En el instrumento se alamcena el numero de cheque asi que esta lista no aplica
		$('#primerRango').bind('keyup',function(e){			
			if($('#tipoInstrumentoID').val()==chequeSBC){
				setTimeout("$('#cajaLista').hide();", 200);
				
			}
		});
		$('#segundoRango').bind('keyup',function(e){			
			if($('#tipoInstrumentoID').val() == chequeSBC){
				setTimeout("$('#cajaLista').hide();", 200);
				
			}
		});
	
		$('#primerRango').bind('keyup',function(e){  
			if($('#tipoInstrumentoID').asNumber()==cajeroATM){
				lista('primerRango', '1', '2','nombreCompleto',$('#primerRango').val(), 'listaCajerosATM.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){ 
			if($('#tipoInstrumentoID').asNumber()==cajeroATM){
				lista('segundoRango', '1', '2','nombreCompleto',$('#segundoRango').val(), 'listaCajerosATM.htm');
		}
		});
		
		$('#primerRango').bind('keyup',function(e) {
			if($('#tipoInstrumentoID').asNumber()==creditos){
				lista('primerRango', '2', '1','creditoID', $('#primerRango').val(),'ListaCredito.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e) {
			if($('#tipoInstrumentoID').asNumber()==creditos){
				lista('segundoRango', '2', '1','creditoID', $('#segundoRango').val(),'ListaCredito.htm');
			}
		});
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==fondeador){
				lista('primerRango', '2', '1', 'nombreInstitFon', $('#primerRango').val(), 'intitutFondeoLista.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==fondeador){
				lista('segundoRango','2','1','nombreInstitFon', $('#segundoRango').val(), 'intitutFondeoLista.htm');
			}
		});

		$('#primerRango').bind('keyup',function(e){		
			if($('#tipoInstrumentoID').asNumber()==inversionesPlazo){
				var camposLista = new Array();
				var parametrosLista = new Array();
				 camposLista[0] = "nombreCliente";
				 camposLista[1] = "estatus";
				 parametrosLista[0] = $('#primerRango').val();			
				 parametrosLista[1] = catStatusInversion.alta;
			lista('primerRango', 2, catTipoListaInversion.principal, camposLista, parametrosLista, 'listaInversiones.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==inversionesPlazo){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCliente";
				camposLista[1] = "estatus";
				parametrosLista[0] = $('#segundoRango').val();
				parametrosLista[1] = catStatusInversion.alta;				
			lista('segundoRango', 2, catTipoListaInversion.principal,camposLista, parametrosLista, 'listaInversiones.htm');
			}
		});
 
		$('#primerRango').bind('keyup',function(e){
				if($('#tipoInstrumentoID').asNumber() == numeroTarjeta){
					if(this.value.length >= 2  && isNaN($('#primerRango').val())){
						lista('primerRango', '1','8','tarjetaDebID', $('#primerRango').val(),'tarjetasDevitoLista.htm');
					}
			 }
		});	
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber() == numeroTarjeta){
				if(this.value.length >= 2 && isNaN($('#segundoRango').val())){
					lista('segundoRango','1','8','tarjetaDebID', $('#segundoRango').val(),'tarjetasDevitoLista.htm');
				}
			}
		});
		
		$('#primerRango').bind('keyup',function(e) {
			if($('#tipoInstrumentoID').asNumber()==cajasVentanilla){
				if(this.value.length >= 2){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "cajaID";
					camposLista[1] = "sucursalID";
					parametrosLista[0] = $('#primerRango').val();
					parametrosLista[1] = parametros.sucursal;
				lista('primerRango', '1', '2', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
			}
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==cajasVentanilla){
				if(this.value.length >= 2){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "cajaID";
					camposLista[1] = "SucursalID";
					parametrosLista[0] = $('#segundoRango').val();
					parametrosLista[1] = parametros.Sucursal;
				lista('segundoRango', '1', '2', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
				}
			}
		});
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==polizaManual){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "concepto";
				parametrosLista[0] = $('#primerRango').val();
				listaAlfanumerica('primerRango', '0', '1', camposLista, parametrosLista, 'polizaContListaVista.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==polizaManual){
			var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "concepto";
				parametrosLista[0] = $('#segundoRango').val();
				listaAlfanumerica('segundoRango', '0', '1', camposLista, parametrosLista, 'polizaContListaVista.htm');
			}
		});
		
/*// Esta lista es de Ahorro y ademas para listar las cuentas bancarias se necesita el numero de la institucion
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==cuentaBancaria){
				var camposLista = new Array();
				var parametrosLista = new Array();						
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#primerRango').val();
			lista('primerRango', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==cuentaBancaria){
				var camposLista = new Array();
				var parametrosLista = new Array();						
				camposLista[0] = "clienteID";
				parametrosLista[0] = $('#segundoRango').val();
				lista('segundoRango','2','3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			}
		});
*/
		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==banco){
				lista('primerRango', '1', '1', 'nombre', $('#primerRango').val(), 'listaInstituciones.htm');
			}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==banco){
				lista('segundoRango', '1', '1', 'nombre', $('#segundoRango').val(), 'listaInstituciones.htm');
			}
		});


		$('#primerRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()== remesas){
				var camposLista = new Array();
				var parametrosLista = new Array();			
				camposLista[0] = "nombre"; 
				parametrosLista[0] = $('#primerRango').val();
			listaAlfanumerica('primerRango', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
				}
		});
		$('#segundoRango').bind('keyup',function(e){
			if($('#tipoInstrumentoID').asNumber()==remesas){
				var  camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombre";
				parametrosLista[0] = $('#segundoRango').val();
			listaAlfanumerica('segundoRango', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
			}
		});
		
		if($('#tipoInstrumentoID').val()!=''){
			if($('#tipoInstrumentoID').val()!=4){
			habilitaControl('primerRango');
			habilitaControl('segundoRango');
			}else{
				habilitaControl('primerRango');
			}			
		}else{
			deshabilitaControl('primerRango');
			deshabilitaControl('segundoRango');
		}

	});
	
	function validaSegudoCentro(idControl){	
		var jqCentro = eval("'#" + idControl + "'");		
		var primerCentro = $('#primerCentroCostos').asNumber();
		var segundoCentro = $('#segundoCentroCostos').asNumber();
		if(!isNaN(segundoCentro)){
			if(esTab == true){		
				 if(primerCentro != '' && segundoCentro != '' ){
						if(primerCentro > segundoCentro){
							alert('El Primer Valor No Puede ser Mayor que el Segundo');					
							$('#segundoCentroCostos').val('');
							$('#descripcionCenCosFin').val('');
							$(jqCentro).focus();
						}
				}
				}// es Tab
		}else{
			$('#segundoCentroCostos').val('0');
			$('#descripcionCenCosFin').val('TODOS');
		}
		
	}
	
	// funcion para validar el rango entre las listas de tipo de Instrumentos
	function validaPrimerRango(idControl){	
		var jqRango = eval("'#" + idControl + "'");		
		var primerRango = $('#primerRango').asNumber();
		var segundoRango = $('#segundoRango').asNumber();
		if(!isNaN(primerRango)){
			if(esTab == true){	
				 if(primerRango >0 && segundoRango >0 ){
					if(primerRango > segundoRango){
						alert('El primer valor no puede ser mayor que el segundo');					
						$('#segundoRango').val('');
						$(jqRango).focus();
					}
				 }
			}// estab
		}else{
			$('#primerRango').val('0');	
		}
		
	}
	function validaSegundoRango(idControl){	
		var jqRango = eval("'#" + idControl + "'");		
		var primerRango = $('#primerRango').asNumber();
		var segundoRango = $('#segundoRango').asNumber();
		if(!isNaN(segundoRango)){
			if(esTab == true){	
				 if(primerRango >0 && segundoRango >=0 ){
					if(primerRango > segundoRango){	
						alert('El Segundo  valor  es mayor al Primero');						
						$('#segundoRango').val($('#primerRango').val());
						$(jqRango).focus();
					}
				 }
			}//estab
		}else{
			$('#primerRango').val('0');
			$('#segundoRango').val('0');
		}
		
	}
	// valida si el tipo de instrumento es cliente
	function validaTipoInstrumento(idControl){
		var jqPrimerRango = eval("'#" + idControl + "'");
		var tipoInstrumento = parseInt($(jqPrimerRango).val());
		var tipoInstrCliente = 4;
			if(tipoInstrumento == tipoInstrCliente){				
			deshabilitaControl('segundoRango');
			}
			else{
				habilitaControl('segundoRango');
			}
		}
		
	// Consulta centro de costos inicial
	function consultaCentroCostosIni(control) {
		var numcentroCosto = $('#primerCentroCostos').val();
		setTimeout("$('#cajaLista').hide();", 200);
			if(numcentroCosto != '' && !isNaN(numcentroCosto) && numcentroCosto >0 && esTab){	
				var centroBeanCon = {  
  					'centroCostoID':$('#primerCentroCostos').val()
				 }; 
				centroServicio.consulta(catTipoConsultaCentro.principal,centroBeanCon,function(centro) { 
					if(centro!=null){
						$('#descripcionCenCosIni').val(centro.descripcion);
					}else{
						alert("El Centro de Costos No Existe");						
						$('#primerCentroCostos').val('0');
						$('#descripcionCenCosIni').val('');
						$('#primerCentroCostos').focus();
						} 
				});
			}else{				
				if(numcentroCosto == '' || numcentroCosto == 0 ){
					$('#primerCentroCostos').val('0');
					$('#descripcionCenCosIni').val('TODOS');	
				}				
			}
		}
	// consulta centro de costos final
	function consultaCentroCostosFin(control) {
		var numcentroCosto = $('#segundoCentroCostos').val();
		setTimeout("$('#cajaLista').hide();", 200);
			if(numcentroCosto != '' && !isNaN(numcentroCosto)  && numcentroCosto >0&& esTab){	
					var centroBeanCon = {  
  					'centroCostoID':$('#segundoCentroCostos').val()
				 }; 
				centroServicio.consulta(catTipoConsultaCentro.principal,centroBeanCon,function(centro) { 
						if(centro!=null){
						$('#descripcionCenCosFin').val(centro.descripcion);
						}
						else{
							alert("El Centro de Costos No Exite");							
							$('#segundoCentroCostos').val('0');
							$('#descripcionCenCosFin').val('');	
							$('#segundoCentroCostos').focus();
							} 
					});
			}else{
				if(numcentroCosto == '' || numcentroCosto == 0 ){
					$('#segundoCentroCostos').val('0');
					$('#descripcionCenCosFin').val('TODOS');	
				}
			}
		}
		
	function ponerCeros(){
		if($('#primerCentroCostos').val() == ''){
			$('#primerCentroCostos').val(0);
			$('#descripcionCenCosIni').val('');			
		}
		else{
			if($('#segundoCentroCostos').val()== ''){
				$('#segundoCentroCostos').val(0);
				$('#descripcionCenCosFin').val('');
			}			
		}		
	}
	
	function ponerCerosRangosIntrumentos(){
		if($('#primerRango').val() == ''){
			$('#primerRango').val(0);					
		}
		else{
			if($('#segundoRango').val()== ''){
				$('#segundoRango').val(0);
			}			
		}		
	}
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
//	FIN VALIDACIONES DE REPORTES
});