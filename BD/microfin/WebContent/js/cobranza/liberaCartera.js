$(document).ready(function(){
	esTab = false;

	var catTipoTransaccionLiberaCartera = {
	  		'liberar':'1'
	};	

	inicializaParametros();
	$('#asignadoID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$.validator.setDefaults({
	      submitHandler: function(event) {  
	    	  if(guardarDatosGridCreditos() == true){
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','asignadoID','funcionExito','funcionError');  
	    	  }	     
	      }
	 });
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {		
			asignadoID: {
				required: true
			}		
		},
		messages: {
			asignadoID: {
				required: 'Especificar Asignado'
			}					
		}		
	});
	
	$('#asignadoID').bind('keyup', function(e){
		lista('asignadoID', '3', '1', 'nombreGestor', $('#asignadoID').val(),'listaAsignaCartera.htm');
	});

	$('#asignadoID').blur(function(){
		if(esTab){
			consultaAsignados(this.id);			
		}
	});
		
	$('#liberar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionLiberaCartera.liberar);	
	});
		
	$('#buscar').click(function(){
		$('#divListaCreditos').html("");
		consultaGridCreditos(1);
	});
	
	$('#generar').click(function() {		
		generaReporte();
	});
	
	//Función consulta los datos de la asignación a liberar 
	function consultaAsignados(idControl){
		var jqGestor = eval("'#" + idControl + "'");
		var numAsignado = $(jqGestor).val();	
		var conAsig = 1;
		var asignaBeanCon = {
			'asignadoID':numAsignado	
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numAsignado != '' && !isNaN(numAsignado) && $('#asignadoID').val() > 0 && esTab){
			asignaCarteraServicio.consulta(conAsig,asignaBeanCon,function(asignacion){
				if(asignacion != null){
					$('#gestorID').val(asignacion.gestorID);
					consultaGestorCobranza('gestorID');
					$('#porcentajeComision').val(asignacion.porcentajeComision);
					$('#tipoAsigCobranzaID').val(asignacion.tipoAsigCobranzaID);	

					$('#divListaCreditos').html("");
					$('#divListaCreditos').hide();	
					$('#fieldsetLisCred').hide();
					deshabilitaBoton('liberar', 'submit');
					deshabilitaBoton('generar', 'submit');
					habilitaBoton('buscar', 'submit');
				}
				else{
					inicializaParametros();
					$('#asignadoID').val('');
					$('#asignadoID').focus();
					alert("No existe la Asignación");
				}
			});
		}else{
			if(isNaN(numAsignado) && esTab){
				inicializaParametros();
				$('#asignadoID').val('');
				$('#asignadoID').focus();
				alert("No existe la Asignación");				
			}else{
				inicializaParametros();
				$('#asignadoID').val('');
				$('#asignadoID').focus();
				alert("No existe la Asignación");
				
			}
		}
	}
	
	//Función consulta los datos del gestro de cobranza
	function consultaGestorCobranza(idControl) {
		var jqGestor = eval("'#" + idControl + "'");
		var numGestor = $(jqGestor).val();	
		var conGestor=1;
		var gestorBeanCon = {
  				'gestorID':numGestor 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numGestor != '' && !isNaN(numGestor) && $('#gestorID').val() > 0 && esTab){
			gestoresCobranzaServicio.consulta(conGestor,gestorBeanCon,function(gestor) {

						if(gestor!=null){
							if(gestor.tipoGestor == 'E'){
								$('#externo').attr("checked",true);
							}else{
								$('#interno').attr("checked",true);
							}
							$('#usuarioID').val(gestor.usuarioID);
							$('#nombre').val(gestor.nombre);	
							$('#apellidoPaterno').val(gestor.apellidoPaterno);
							$('#apellidoMaterno').val(gestor.apellidoMaterno);
							
							$('#telefonoParticular').val(gestor.telefonoParticular);
							$('#telefonoCelular').val(gestor.telefonoCelular);
							$("#telefonoParticular").setMask('phone-us');
							$("#telefonoCelular").setMask('phone-us');
							
							
							$('#porcentajeComision').val(gestor.porcentajeComision);
							$('#tipoAsigCobranzaID').val(gestor.tipoAsigCobranzaID);
							if(gestor.estatus == "A"){
								$('#estatus').val("ACTIVO");
							}else{
								if(gestor.estatus == "B"){
									$('#estatus').val("BAJA");
								}								
							}
										
						}else{					
							limpiaDatosGestor();
							$('#gestorID').focus();
							$('#gestorID').val('');
							alert("No Existe el Gestor de Cobranza");
						}  
				});
			}else{
				if(isNaN(numGestor) || $('#gestorID').val() <= 0 && esTab && numGestor != ''){
					limpiaDatosGestor();
					$('#gestorID').focus();
					$('#gestorID').val('');
					alert("No Existe el Gestor de Cobranza");
				}
			}
	}

	//Función que construye la cadena de creditos seleccionados del grid a liberar
	function guardarDatosGridCreditos(){		
		var mandar = verificarVacios();
		if(consultaNumFilasSelec()>0){
			if(mandar != 1){
				$('#listaGridCredLib').val("");
			  		
				$('tr[name=renglons]').each(function() {
					var numero= this.id.substr(8,this.id.length);
	
					var creditoID= eval("'#creditoID" + numero + "'");   
					var estatusCredLib= eval("'#estatusCredLib" + numero + "'");      
					var diasAtrasoLib= eval("'#diasAtraso" + numero + "'");   
					var saldoCapitalLib= eval("'#saldoCapitalLib" + numero + "'");   
					var saldoInteresLib= eval("'#saldoInteresLib" + numero + "'");   
					var saldoMoratorioLib= eval("'#saldoMoratorioLib" + numero + "'"); 
					var motivoLiberacion= eval("'#motivoLiberacion" + numero + "'");     
					var liberar= eval("'#esLiberadocheck" + numero + "'");   
					
					if ($(liberar).val()=="N"){
							$('#listaGridCredLib').val($('#listaGridCredLib').val() + '['+
							$('#asignadoID').val() + ']' +
							$(creditoID).val() +']'+
							$(estatusCredLib).val() +']'+
							$(diasAtrasoLib).val() +']'+
							$(saldoCapitalLib).val().replace(/,/g, "") +']'+
							$(saldoInteresLib).val().replace(/,/g, "") +']'+
							$(saldoMoratorioLib).val().replace(/,/g, "") +']'+
							$(motivoLiberacion).val() +']'+
							$(liberar).val());
					}			
				});
				return true;
			}else{
				alert("Ingresar el Motivo de la Liberación");
				return false;
			}
		}else{
			alert('No ha Seleccionado un Crédito');
			return false;
		} 
	}
	
	

	//Función que genera un reporte en excel solo de los créditos liberados  
	function generaReporte(){
		var parametroBean = consultaParametrosSession();
		
		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaAplicacion;

		var pagina='reporteLiberaCartera.htm?asignadoID='+$('#asignadoID').val()+ 
							'&tipoLista=2'+ 
							'&tipoReporte=2' + 
							'&nombreInstitucion='	+varNombreInstitucion+ 
							'&claveUsuario='+varClaveUsuario.toUpperCase()+ 
							'&fechaSis='+ varFechaSistema+ 
							'&gestorID='+ $('#gestorID').val()+ 
							'&nombreCompleto='+ $('#nombre').val()+' '+$('#apellidoPaterno').val()+' '+$('#apellidoMaterno').val();
		window.open(pagina);	   
	}
	
});

//Función que colsulta los créditos de la asignación 
function consultaGridCreditos(tipoLista){
	$('#listaGridCredLib').val('');
	var params = {};
	params['tipoLista'] = tipoLista;
	params['asignadoID'] = $('#asignadoID').val();		

	$.post("liberaCreditosGridVista.htm", params, function(data){
		if(data.length > 0) {	
			$('#divListaCreditos').html(data);
			$('#divListaCreditos').show();	
			$('#fieldsetLisCred').show();
			
			var numFilas=consultaFilas();		
			if(numFilas == 0 ){;
				$('#divListaCreditos').html("");
				$('#divListaCreditos').hide();	
				$('#fieldsetLisCred').hide();
				deshabilitaBoton('liberar', 'submit');
				deshabilitaBoton('generar', 'submit');
				alert('No se Encontraron Coincidencias');
			}else{
				if(tipoLista == 1){
					habilitaBoton('liberar', 'submit');
				}						
			}
			hasChecked();
			
			// si ya estan liberados todos los creditos se deshbilita la opcion de seleccionarlos todos
			if(consultaNumFilasSelec() == consultaFilas()){
				deshabilitaControl('selecTodos'); 
				deshabilitaBoton('liberar', 'submit');	
				habilitaBoton('generar', 'submit');											
			}else{
				habilitaBoton('liberar', 'submit');
			}
		}else{				
			$('#divListaCreditos').html("");
			$('#divListaCreditos').hide();
			$('#fieldsetLisCred').hide();
			deshabilitaBoton('liberar', 'submit');
			deshabilitaBoton('generar', 'submit');
			alert('No se Encontraron Coincidencias');	
		}
	});
}

//Función que inicializa los campso de la pantalla 
function inicializaParametros(){
	inicializaForma('formaGenerica','asignadoID');

	deshabilitaBoton('buscar', 'submit');
	$('#tipoAsigCobranzaID').val('');
	funcionCargaComboTipoAsig();
	var parametroBean = consultaParametrosSession();
	$('#usuarioLogeadoID').val(parametroBean.numeroUsuario);
	$('#fechaSis').val(parametroBean.fechaSucursal);
	
	$('#divListaCreditos').html("");
	$('#divListaCreditos').hide();
	$('#fieldsetLisCred').hide();
	deshabilitaBoton('liberar', 'submit');
	deshabilitaBoton('generar', 'submit');
}

//Función que carga las opciones del combo tipo de asignación
function funcionCargaComboTipoAsig(){
	dwr.util.removeAllOptions('tipoAsigCobranzaID'); 
	gestoresCobranzaServicio.listaCombo(1, function(tipoAsignaciones){
		dwr.util.addOptions('tipoAsigCobranzaID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('tipoAsigCobranzaID', tipoAsignaciones, 'tipoAsigCobranzaID', 'descripcion');
	});
}

//Función consulta el número de filas del grid 
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;	
}

//Función que verifica que los créditos que se liberan tengan registrado un motivo de la liberación 
function verificarVacios(){	
	var numCred = consultaFilas();	
	
	for(var i = 1; i <= numCred; i++){
		var asignado = document.getElementById("esLiberadocheck"+i+"").value;				
		var motivo = document.getElementById("motivoLiberacion"+i+"").value;
		if (motivo =="" && asignado=="N"){ 				
				document.getElementById("motivoLiberacion"+i+"").focus();
 					return 1; 
		}
	}
		
}



//Función que al dar click en un check de la lista de creditos, asigna valor si es seleccionado o no
function realiza(control){	
	var  si='S';
	var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = no;		
	}else{
		document.getElementById(control).value = si;
	}
		
}

//Función selecciona todos los checks del listado de creditos
function seleccionaTodos(control){
	var  si='S';
	var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'esLiberadocheck" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Sicheck='S';
			if(valorChecked==Sicheck){	
				$('#esLiberadocheck'+numero).attr('checked','true');
				document.getElementById(jqIdChecked).value = no;
			}
		});
	}else{
		document.getElementById(control).value = no;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'esLiberadocheck" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Nocheck='N';
			if(valorChecked==Nocheck){	
				$('#esLiberadocheck'+numero).attr('checked',false);	
				document.getElementById(jqIdChecked).value = si;
			}
		});
	}
}

//Función que al consultar el listado de creditos marca los creditos liberados y a todos les agrega el formato moneda
function hasChecked(){	
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdChecked = eval("'esLiberadocheck" + numero+ "'");
		var jqMotivoLib = eval("'motivoLiberacion" + numero+ "'");	
		var valorChecked= document.getElementById(jqIdChecked).value;	
		var liberado='N';
		if(valorChecked==liberado){
			$('#esLiberadocheck'+numero).attr('checked','false');
			deshabilitaControl(jqIdChecked);
			deshabilitaControl(jqMotivoLib);
		}else{
			$('#esLiberadocheck'+numero).attr('checked',false);
		}
		
		$('#montoCredito'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoCapital'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoInteres'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoMoratorio'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoCapitalLib'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoInteresLib'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoMoratorioLib'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	
	});		
}

//Función consulta el número de créditos que se seleccionaron
function consultaNumFilasSelec(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var liberar= eval("'#esLiberadocheck" + numero + "'");   
		
		if ($(liberar).val()=="N"){
			totales++;
		}		
	});
	return totales;
}

//Función de éxito de la transacción
function funcionExito(){

	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			$('#divListaCreditos').html("");
			consultaGridCreditos(1);
			habilitaBoton('generar', 'submit');
			$('#generar').focus();				
		}
        }, 50);
	}
	
	
}

//Función de error de la transacción
function funcionError(){
	
}