$(document).ready(function() {	
	var parametroBean = consultaParametrosSession();
	 $('#fecha').val(parametroBean.fechaSucursal);
	esTab = true;
	
	var catTipoTransaccionAclaracion = {
			'agrega'		 	: '3'
	};
		
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#reimprimir').hide();
	
	$('#reimprimir').click(function () {
		resultado();
	});
	
	
	deshabilitaBoton('agrega','submit');
	agregaFormatoControles('formaGenerica');
	$('#tipoTarjetaD').focus();	
		$.validator.setDefaults({
			
	      submitHandler: function(event) {
	 	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','reporteID', 
	    			  'funcionExito','funcionError');
	    	 	      }
	      
	});
	
	$('#reporteID').blur(function(){
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			validaAclaracion(this.id);
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			validaCreAclaracion(this.id);
		}
		$('#estatusResult').val('');
		$('#detalleResolucion').val('');
		$('#usuarioID').val('');
		$('#nombreCompleto').val('');
	});
	$('#usuarioID').blur(function() {
  		validaUsuario(this);
	});
	$('#tipoTarjetaD').blur(function() {
		$('#tipoTarjetaC').focus();
	});
	$('#tipoTarjetaC').blur(function() {
		$('#reporteID').focus();
	});

	$('#agrega').click(function() {
		var detalle ='';
		var detalleResolucion = $('#detalleResolucion').val();
		if(detalle == detalleResolucion){
			alert('Especifique el Detalle de Resolución');  
			$('#detalleResolucion').focus();
			 event.preventDefault();
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionAclaracion.agrega);
		
		}
	});

	$('#tipoTarjetaD').click(function() {
		limpiarFormulario();
		$('#reporteID').val('');
		deshabilitaBoton('agrega','submit');
		$('#tipoTarjetaC').attr("checked",false);
	});

	$('#tipoTarjetaC').click(function() {
		limpiarFormulario();
		$('#reporteID').val('');
		deshabilitaBoton('agrega','submit');
		$('#tipoTarjetaD').attr("checked",false);
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});
	
	$('#reporteID').bind('keyup',function(e) {
		if($('#tipoTarjetaD').attr("checked") == true && $('#tipoTarjetaC').attr("checked") == false){
			lista('reporteID', '3', '4', 'reporteID', $('#reporteID').val(), 'aclaraTarjListaVista.htm');
		}else if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == true){
			lista('reporteID', '3', '6', 'reporteID', $('#reporteID').val(), 'aclaraTarjListaVista.htm');
		}	
		
	});
	
	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			
			reporteID: {
				number: true,
				required: true,
			},
			tarjetaDebID: {
				required : true,
			},
			resuelto: {
				required: true
			},
			
			estatusResult:{
  				required: true
  			},
  			usuarioID:{
  				required: true
  			}  			
		},
		messages : {
			
			reporteID: {
				number: 'Sólo números',
				required: 'Especificar Número de Reporte.',				
			},
			tarjetaDebID: {
				required : 'Especificar el Número de Tarjeta'
			},
			resuelto: {
				required: 'Especificar la Resolución de la Aclaración'
			},
			estatusResult: {
				required: 'Especificar el Estatus de Resolución'
			},
			usuarioID: {
				required: 'Especificar el Usuario'
			}
		}
	});
	
	// ------------ Validaciones de Controles-------------------------------------
	function validaAclaracion(idControl){
		var jqTipoAcla  = eval("'#" + idControl + "'");
		var numTipoAcla = $(jqTipoAcla).val();
		var tipoAclaraBeanCon = {
				'reporteID' : numTipoAcla,
				'tipoTarjeta': 'D'
			};
		if(numTipoAcla != '' && !isNaN(numTipoAcla) ){
				aclaracionServicio.consulta(4,tipoAclaraBeanCon,function(aclaracionBean) {
					if(aclaracionBean != null){
						$('#reporteID').val(aclaracionBean.reporteID);
						$('#tarjetaDebID').val(aclaracionBean.tarjetaDebID);
						$('#estatus').val(aclaracionBean.estatus);
						validaEstatus('estatus');
						$('#tipoTarjeta').val(aclaracionBean.tipoTarjeta);						
						$('#clienteID').val(aclaracionBean.clienteID);
						$('#nombre').val(aclaracionBean.nombre);
						$('#numCuenta').val(aclaracionBean.numCuenta);
						$('#descCuenta').val(aclaracionBean.tipoCuenta);
						$('#cuentaAho').show();
						$('#producto').hide();
						$('#detalleReporte').val(aclaracionBean.detalleReporte);
						$('#descMovimiento').val(aclaracionBean.descMovimiento);
						$('#detalleResolucion').val(aclaracionBean.detalleResolucion);
						if (aclaracionBean.corporativoID == 0 || aclaracionBean.corporativoID == '' || aclaracionBean.corporativoID == null) {
							$('#cteCorpTr').hide();
							$('#corporativoID').val('');
							$('#corporativo').val('');
						}else {
							$('#cteCorpTr').show();
							$('#corporativoID').val(aclaracionBean.corporativoID);
							$('#corporativo').val(aclaracionBean.nombreCorp);	
						}
						
						
					}else{
						alert("El Número de Reporte de Aclaración no Existe");
						limpiarFormulario();
						$('#reporteID').val('');
						$('#reporteID').focus();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('resolucion','submit');
						$('#reimprimir').hide();
					}
				});
			}
		}

	function validaCreAclaracion(idControl){
		var jqTipoAcla  = eval("'#" + idControl + "'");
		var numTipoAcla = $(jqTipoAcla).val();
		var tipoAclaraBeanCon = {
				'reporteID' : numTipoAcla,
				'tipoTarjeta': 'C'
			};
		if(numTipoAcla != '' && !isNaN(numTipoAcla) ){
				aclaracionServicio.consulta(6,tipoAclaraBeanCon,function(aclaracionBean) {
					if(aclaracionBean != null){
						$('#reporteID').val(aclaracionBean.reporteID);
						$('#tarjetaDebID').val(aclaracionBean.tarjetaDebID);
						$('#estatus').val(aclaracionBean.estatus);
						validaEstatus('estatus');
						$('#tipoTarjeta').val(aclaracionBean.tipoTarjeta);						
						$('#clienteID').val(aclaracionBean.clienteID);
						$('#nombre').val(aclaracionBean.nombre);
						$('#producto').show();
						$('#cuentaAho').hide();
						$('#productoID').val(aclaracionBean.productoID);
						$('#nombreProducto').val(aclaracionBean.nombreProducto);
						$('#detalleReporte').val(aclaracionBean.detalleReporte);
						$('#descMovimiento').val(aclaracionBean.descMovimiento);
						$('#detalleResolucion').val(aclaracionBean.detalleResolucion);
						if (aclaracionBean.corporativoID == 0 || aclaracionBean.corporativoID == '' || aclaracionBean.corporativoID == null) {
							$('#cteCorpTr').hide();
							$('#corporativoID').val('');
							$('#corporativo').val('');
						}else {
							$('#cteCorpTr').show();
							$('#corporativoID').val(aclaracionBean.corporativoID);
							$('#corporativo').val(aclaracionBean.nombreCorp);	
						}
						
						
					}else{
						alert("El Número de Reporte de Aclaración no Existe");
						limpiarFormulario();
						$('#reporteID').val('');
						$('#reporteID').focus();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('resolucion','submit');
						$('#reimprimir').hide();
					}
				});
			}
		}
	
	function validaEstatus() {
		var estatus=$('#estatus').val();
		var Seguimiento		="S";
		var Alta 			="A";
		var Resuelta 		="R";
	
		setTimeout("$('#cajaLista').hide();", 200);	
		
		if(estatus == Alta){
			 $('#estatus').val('ALTA');
			 habilitaBoton('agrega','submit');
			 habilitaBoton('resolucion','submit');
			 $('#agrega').show();
			 $('#reimprimir').hide();
		}
		if(estatus == Seguimiento){
			 $('#estatus').val('SEGUIMIENTO');
			 habilitaBoton('agrega','submit');
			 habilitaBoton('resolucion','submit');
			 $('#agrega').show();
			 $('#reimprimir').hide();
		}
		if(estatus == Resuelta){
			 $('#estatus').val('RESUELTA');
			 deshabilitaBoton('agrega','submit');
			 deshabilitaBoton('resolucion','submit');
			 $('#agrega').hide();
			 $('#reimprimir').show();
		}
			
	}
	function validaUsuario(control) {
		var numUsuario = $('#usuarioID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioBeanCon = {
				'usuarioID':numUsuario 
		};
		if(numUsuario != '' && !isNaN(numUsuario)){
				
				usuarioServicio.consulta(1,usuarioBeanCon,function(usuario) {
					if(usuario!=null){
				
						$('#usuarioID').val(usuario.usuarioID);	
						$('#nombreCompleto').val(usuario.nombreCompleto);	
										
					}else{
						alert("No Existe el Usuario");
						$('#usuarioID').focus();
						$('#usuarioID').select();																
					}
				});			
			}							
		}

	function consultarParametrosBean() {
		var parametroBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
		$('#numeroSucursal').val(parametroBean.sucursal);
		$('#nombreSucursal').val(parametroBean.nombreSucursal);
		$('#usuarioID').val(parametroBean.nombreUsuario);
		$('#nombreUsuario').val(parametroBean.nombreUsuario);
	}

});//	FIN VALIDACIONES DE REPORTES

//funcion que valida fecha 
	function esFechaValida(fecha){
		var fecha2 = parametroBean.fechaSucursal;
		if(fecha == ""){return false;}
		if (fecha != undefined  ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de fecha no válido (aaaa-mm-dd)");
				return true;
			}
			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;
			var mes2=  fecha2.substring(5, 7)*1;
			var dia2= fecha2.substring(8, 10)*1;
			var anio2= fecha2.substring(0,4)*1;
			if(anio>anio2 || anio==anio2&&mes>mes2 || anio==anio2&&mes==mes2&&dia>dia2 ){
				alert("Fecha introducida es mayor a la actual.");
				return true;
			}		
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
					alert("Fecha introducida errónea.");
				return true;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
				return true;
			}
			return false;
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

	$(".contador").each(function(){
		var longitud = $(this).val().length;
		$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b>/2000');
		$(this).keyup(function(){
			var nueva_longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b>/2000');
			if (nueva_longitud == "2000") {
				$('#longitud_textarea').css('color', '#ff0000');
			}
		});
	});
	function consultarParametrosBean() {
		var parametroBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
		$('#numeroSucursal').val(parametroBean.sucursal);
		$('#nombreSucursal').val(parametroBean.nombreSucursal);
		$('#usuarioID').val(parametroBean.nombreUsuario);
		$('#nombreUsuario').val(parametroBean.nombreUsuario);
	}
	
	function limpiarFormulario(){
		$('#estatus').val('');
		$('#tarjetaDebID').val('');
		$('#clienteID').val('');
		$('#nombre').val('');
	
		$('#detalleReporte').val('');
		$('#estatusResult').val('');
		$('#detalleResolucion').val('');
		$('#usuarioID').val('');
		$('#descMovimiento').val('');
		$('#numCuenta').val('');
		$('#descCuenta').val('');	
		$('#usuarioID').val('');
	$('#nombreCompleto').val('');
	}

	function funcionExito (){
	resultado();
		$('#estatus').val('');
		$('#tarjetaDebID').val('');
		$('#clienteID').val('');
		$('#nombre').val('');
		$('#claveID').val('');
		$('#detalleReporte').val('');
		$('#estatusResult').val('');
		$('#detalleResolucion').val('');
		$('#descMovimiento').val('');
		$('#numCuenta').val('');
		$('#descCuenta').val('');
		$("#detalleResolucion").empty();
		$("#detalleReporte").empty();
		$("#resuelto").empty();
		deshabilitaBoton('agrega','submit');
		
	}


	function funcionError (){
	}
	
	function resultado(){
	window.open('resolucionAclaracion.htm?nombreInstitucion='+parametroBean.nombreInstitucion+
				'&tarjetaDebID='+$('#tarjetaDebID').val()+'&usuarioID='+$('#usuarioID').val()+				
				'&reporteID='+$('#reporteID').val()+'&nombreUsuario='+$('#nombreCompleto').val()+'&fechaEmision='+$('#fecha').val()+'&tipoReporte=1','_blank');
	}
 	
	function validaSoloNumeros() {
		if ((event.keyCode < 48) || (event.keyCode > 57))
  		event.returnValue = false;
	}