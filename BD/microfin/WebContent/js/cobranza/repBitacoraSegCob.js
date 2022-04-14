$(document).ready(function() {
	esTab = false;

	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#fechaIniReg').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});		

	$.validator.setDefaults({submitHandler: function(event) {
	   
	}});	
	
	$('#generar').click(function() {	
		if($('#limiteReglones').asNumber() <= 0){
			alert('Especifique el Límite de Renglones');
			$('#limiteReglones').focus();
		}else{
			if($('#pdf').attr('checked')==true){
				generaReporte(1);
			}else{
				if($('#excel').attr('checked')==true){
					generaReporte(2);
				}
			}
		}				
	});	
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '9', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	
	$('#creditoID').blur(function(){
		if(esTab){
			consultaCredito(this.id);
		}
	});	
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		if(esTab){
			consultaCliente('clienteID');
		}					
	});
	
	$('#usuarioReg').bind('keyup',function(e){
		lista('usuarioReg', '2', '1', 'nombreCompleto', $('#usuarioReg').val(), 'listaUsuarios.htm');
	});
		
	$('#usuarioReg').blur(function() {
		if(esTab){
			validaUsuario(this);
		}  		
	});
	
	$('#fechaIniReg').change(function(){
		var Xfecha= $('#fechaIniReg').val();
		var Yfecha= $('#fechaFinReg').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaIniReg').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				alert("La Fecha de Inicio no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaIniReg').val(fechaSis);
				$('#fechaFinReg').val(fechaSis);
				$('#fechaIniReg').focus();
			}else{
				if( mayor(Xfecha, Yfecha)){
					alert("La Fecha de Inicio no Puede ser Mayor a la Fecha Final")	;
					$('#fechaIniReg').val(Yfecha);
					$('#fechaIniReg').focus();
				}else{
					$('#fechaIniReg').focus();						
				}
			}
		}else{
			$('#fechaIniReg').val(Yfecha);
			$('#fechaIniReg').focus();
		}
	});	

	$('#fechaFinReg').change(function(){
		var Xfecha= $('#fechaFinReg').val();
		var Yfecha= $('#fechaIniReg').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaFinReg').val(fechaSis);
			if( mayor(Xfecha, fechaSis)){
				alert("La Fecha Final no Puede ser Mayor a la Fecha del Sistema");
				$('#fechaFinReg').val(fechaSis);
				$('#fechaFinReg').focus();
			}else{
				if( mayor(Yfecha, Xfecha)){
					alert("La Fecha Final no Puede ser Menor a la Fecha de Inicio")	;
					$('#fechaFinReg').val(Yfecha);
					$('#fechaFinReg').focus();
				}else{
					$('#fechaFinReg').focus();						
				}
			}
		}else{
			$('#fechaFinReg').val(fechaSis);
			$('#fechaFinReg').focus();
		}
	});		

	$('#fechaIniProm').change(function(){
		var Xfecha= $('#fechaIniProm').val();
		var Yfecha= $('#fechaFinProm').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaIniProm').val(fechaSis);

			if( mayor(Xfecha, Yfecha)){
				alert("La Fecha Inicio Promesa no Puede ser Mayor a la Fecha Final Promesa")	;
				$('#fechaIniProm').val(Yfecha);
				$('#fechaIniProm').focus();
			}else{
				$('#fechaIniProm').focus();						
			}
		}else{
			$('#fechaIniProm').val(Yfecha);
			$('#fechaIniProm').focus();
		}
	});	

	$('#fechaFinProm').change(function(){
		var Xfecha= $('#fechaFinProm').val();
		var Yfecha= $('#fechaIniProm').val();
		var fechaSis= parametroBean.fechaSucursal;
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaFinProm').val(fechaSis);
			if( mayor(Yfecha, Xfecha)){
				alert("La Fecha Final Promesa no Puede ser Menor a la Fecha de Inicio");
				$('#fechaFinProm').val(Yfecha);
				$('#fechaFinProm').focus();
			}else{
				$('#fechaFinProm').focus();						
			}
		}else{
			$('#fechaFinProm').val(fechaSis);
			$('#fechaFinProm').focus();
		}
	});	
	
	$('#accionID').change(function(){
		var accion = $('#accionID').val();
		if(accion == ''){
			dwr.util.removeAllOptions('respuestaID');
			dwr.util.addOptions('respuestaID', {'':'TODAS'});	
		}else{
			funcionCargaComboTipoRespuesta(accion);
		}		
	});
	
	// Funcion para generar el reporte en excel o PDF de la bitacora de seguimiento
	function generaReporte(tipoReporte){
		
		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaSucursal;

		var pagina='reporteBitacoraSegCob.htm?tipoLista=1'+ 
							'&tipoReporte=' + tipoReporte+ 
							'&fechaIniReg=' + $('#fechaIniReg').val()+ 
							'&creditoID=' + $('#creditoID').val()+ 
							'&fechaFinReg=' + $('#fechaFinReg').val()+ 
							'&usuarioReg=' + $('#usuarioReg').val()+ 
							
							'&accionID=' + $('#accionID').val()+ 							
							'&fechaIniProm=' + $('#fechaIniProm').val()+ 
							'&respuestaID=' + $('#respuestaID').val()+ 
							'&fechaFinProm=' + $('#fechaFinProm').val()+ 
							'&clienteID=' + $('#clienteID').val()+ 
							
							'&limiteReglones=' + $('#limiteReglones').val()+ 							
							'&fechaSis='+ varFechaSistema+ 
							'&claveUsuario='+varClaveUsuario.toUpperCase()+
							'&nombreInstitucion='	+varNombreInstitucion+
							
							'&desUsuRec='	+$('#nombreUsu').val()+
							'&descAccion='	+$("#accionID option:selected").text()+
							'&descRespuesta='	+$("#respuestaID option:selected").text();
		window.open(pagina);	   
	}
	
	// Funcion principal consulta creditos
	function consultaCredito(controlID){
		var numCredito = $('#'+controlID).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && numCredito>0){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'clienteID':$('#clienteID').val()
				}; 
			creditosServicio.consulta(18, creditoBeanCon,function(credito){
				if(credito!=null){
					$('#creditoID').val(credito.creditoID);
					$('#clienteID').val(completaCerosIzq(credito.clienteID,10));
					consultaCliente('clienteID');
				}else{
					alert("No Existe el Credito");
					$('#creditoID').val('');
					$('#clienteID').val('');
					$('#nombreCli').val('');
					$('#creditoID').focus();
					$('#creditoID').select();	
				}
			});
		}else{
			if(isNaN(numCredito)){
				alert("No Existe el Credito");
				$('#creditoID').val('');
				$('#clienteID').val('');
				$('#nombreCli').val('');
				$('#creditoID').focus();
				$('#creditoID').select();
			}else{
				if(numCredito =='' || numCredito == 0){
					$('#creditoID').val('');
				}
			}
		}
	}
	
	// Funcion que consulta el nombre del cliente 
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)  && numCliente>0){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);	
					$('#nombreCli').val(cliente.nombreCompleto);			
				}else{
					alert("No Existe el Socio");
					$('#clienteID').val('0');
					$('#nombreCli').val('TODOS');
					$('#clienteID').focus();
					$('#clienteID').select();	
				}    	 						
			});
		}else{
			if(isNaN(numCliente)){
				alert("No Existe el Socio");
				$('#clienteID').val('0');
				$('#nombreCli').val('TODOS');
				$('#clienteID').focus();
				$('#clienteID').select();				
			}else{
				if(numCliente =='' || numCliente == 0){
					$('#clienteID').val('0');
					$('#nombreCli').val('TODOS');
				}
			}
			
		}
	}
	
	// Funcion para consultar el usuario
	function validaUsuario(control) {
		var numUsuario = $('#usuarioReg').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario > 0){
				var usuarioBeanCon = {
						'usuarioID':numUsuario 
				};	
				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
						$('#usuarioReg').val(usuario.usuarioID);
						$('#nombreUsu').val(usuario.clave.toUpperCase());						
					}else{
						alert("No Existe el Usuario");
						$('#usuarioReg').val('0');
						$('#nombreUsu').val('TODOS');
						$('#usuarioReg').focus();
						$('#usuarioReg').select();																
					}
				});			
										
		}else{
			if(isNaN(numUsuario)){
				alert("No Existe el Usuario");
				$('#usuarioReg').val('0');
				$('#nombreUsu').val('TODOS');
				$('#usuarioReg').focus();
				$('#usuarioReg').select();				
			}else{
				if(numUsuario =='' || numUsuario == 0){
					$('#usuarioReg').val('0');
					$('#nombreUsu').val('TODOS');
				}
			}
		}
	}
	
	// Funcion valida fecha formato (yyyy-MM-dd)
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha No Válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}

	// Valida si fecha > fecha2: true else false
	function mayor(fecha, fecha2){ 
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
	
	// Funcion que inicializa todos los campos de la pantalla
	function inicializaParametros(){
		inicializaForma('formaGenerica','');

		$('#fechaIniReg').val(parametroBean.fechaSucursal);
		$('#fechaFinReg').val(parametroBean.fechaSucursal);
		$('#fechaIniProm').val(parametroBean.fechaSucursal);
		$('#fechaFinProm').val(parametroBean.fechaSucursal);
		$('#limiteReglones').val('20');

		$('#accionID').val('');
		funcionCargaComboTipoAccion();
		$('#respuestaID').val('');	

		$('#usuarioReg').val('0');
		$('#nombreUsu').val('TODOS');
		$('#clienteID').val('0');
		$('#nombreCli').val('TODOS');

		$('#pdf').attr("checked",true);
		
	}
	
	// Funcion carga todas las opciones en el combo tipo de accion
	function funcionCargaComboTipoAccion(){
		dwr.util.removeAllOptions('accionID'); 
		tipoAccionCobServicio.listaCombo(2, function(tipoAacciones){
			dwr.util.addOptions('accionID', {'':'TODAS'});	
			dwr.util.addOptions('accionID', tipoAacciones, 'accionID', 'descripcion');
		});
	}
	
	// Función carga todas las opciones en el combo tipo de respuestas
	function funcionCargaComboTipoRespuesta(accion){
		var beanCon ={
			'accionID' : accion 
		};
		dwr.util.removeAllOptions('respuestaID'); 
		tipoRespuestaCobServicio.listaCombo(2,beanCon, function(tipoAacciones){
			dwr.util.addOptions('respuestaID', {'':'TODAS'});	
			dwr.util.addOptions('respuestaID', tipoAacciones, 'respuestaID', 'descripcion');
		});
	}	
	
}); // fin document ready


//Función solo Enteros sin Puntos ni Caracteres Especiales 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}

//Conpleta ceros a la izquierda
function completaCerosIzq(obj,longitud) {
	var numtmp= String(obj);
 	while (numtmp.length<longitud){  		
 		numtmp = '0'+numtmp;
	}
 	return numtmp;
}
