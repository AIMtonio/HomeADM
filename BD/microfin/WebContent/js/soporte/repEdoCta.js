var tipoReporteEdoCta = {
		'Excel': 1
	};

var tipoReporte = tipoReporteEdoCta.Excel;

$(document).ready(function() {
	esTab = false;

	var parametroBean = consultaParametrosSession();
	
	inicializaParametros();
	$('#anioMes').focus();
	
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
		if ($('#formaGenerica').valid()) {
			generaExcel();
		}
	});	
	
	$('#anioMes').bind('keyup',function(e) {
		if ($(this).val().length > 0) {
			habilitaBoton('generar', 'submit');
		} else {
			deshabilitaBoton('generar', 'submit');
		}
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'anioMes';
		parametrosLista[0] = $('#anioMes').val();
		listaAlfanumerica('anioMes', '2', '5', camposLista, parametrosLista, 'listaPeriodos.htm');
	});
	
	$('#anioMes').bind('keypress', function(e){
		return validaSoloNumero(e,this);		
	});
	
	$('#anioMes').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(isNaN($('#anioMes').val()) || $('#anioMes').val() == '') {
			$('#anioMes').val("");
			deshabilitaBoton('generar', 'submit');
		}
		if((isNaN($('#anioMes').val()) || $('#anioMes').val() == '') && esTab) {
			$('#anioMes').val("");
			setTimeout( function() {
				$('#anioMes').focus();
			}, 0);
			deshabilitaBoton('generar', 'submit');
		}
		if(($('#anioMes').val().substring(0, 4) < 1990 || $('#anioMes').val().substring(0, 4) > 2100) && $('#anioMes').val() != '' && esTab) {
			mensajeSis('Periodo incorrecto');
			$('#anioMes').val('');
			deshabilitaBoton('generar', 'submit');
			setTimeout( function() {
				$('#anioMes').focus();
			}, 0);
		}
	});
	
	$('#clienteID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'nombreCompleto';
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});
		
	$('#clienteID').blur(function() {
		if(esTab){
			funcionConsultaCliente(this.id);
		}  		
	});
	
	$('#formaGenerica').validate({
		rules:{
			anioMes: {
				required: true
			}
		},messages:{
			anioMes: {
				required:'Especifique periodo de generacion'
			}
		}
	});
}); // fin document ready




// Funcion para consultar el cliente
function funcionConsultaCliente(idControl) {
	var jqCliente  = eval("'#" + idControl + "'");
	var varclienteID = $(jqCliente).val();	
	var conCliente = 1;
	var rfc = ' ';
	setTimeout("$('#cajaLista').hide();", 200);	

	if(varclienteID != '' && !isNaN(varclienteID) && varclienteID!=0){
		clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
			if(cliente!=null){
				if(cliente.estatus != 'I'){
					$('#clienteID').val(cliente.numero);
					var tipo = (cliente.tipoPersona);
					if(tipo=='A'){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo=='F'){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo=='M'){
						$('#nombreCliente').val(cliente.razonSocial);
					}
				}else{
					mensajeSis("El Cliente se encuentra Inactivo");
					$('#clienteID').val('0');
					$('#nombreCliente').val('TODOS');
					$('#clienteID').focus();
					$('#clienteID').select();	
				}
			}else{
				mensajeSis("No Existe el Cliente");
				$('#clienteID').val('0');
				$('#nombreCliente').val('TODOS');
				$('#clienteID').focus();
				$('#clienteID').select();	
			}
		});
	}else{
		if(isNaN(varclienteID)){
			mensajeSis("No Existe el Cliente");
			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
			$('#clienteID').focus();
			$('#clienteID').select();				
		}else{
			if(varclienteID =='' || varclienteID == 0){
				$('#clienteID').val('0');
				$('#nombreCliente').val('TODOS');
			}
		}
	}
}


// Funcion para generar el reporte en Excel de los estados de cuenta
function generaExcel(){	
	
	var anioMes = $('#anioMes').val();	 
	var clienteID = $('#clienteID').val();
	var nombreCliente = $('#nombreCliente').val();
	var estatus = $('#tipoEdoCta').val();
	var nombreEstatus = $('#tipoEdoCta option[value='+estatus+']').text();
	var claveUsuario = parametroBean.claveUsuario;
	var nombreUsuario = parametroBean.claveUsuario;
	var nombreSucursal =  parametroBean.nombreSucursal; 		
	var nombreInstitucion =  parametroBean.nombreInstitucion; 
	var fechaEmision =  parametroBean.fechaSucursal;
	var hora='';
	var horaEmision= new Date();
	hora = horaEmision.getHours();
	hora = hora+':'+horaEmision.getMinutes();
	hora = hora+':'+horaEmision.getSeconds();

	window.open('reporteEdosCta.htm?'
			+'anioMes='+anioMes
			+'&clienteID='+clienteID
			+'&nombreCliente='+nombreCliente
			+'&estatus='+estatus
			+'&nombreEstatus='+nombreEstatus
			+'&tipoReporte='+tipoReporte
			+'&claveUsuario='+claveUsuario
			+'&nombreUsuario='+nombreUsuario
			+'&nombreInstitucion='+nombreInstitucion
			+'&nombreSucursal='+nombreSucursal
			+'&fechaEmision='+fechaEmision
			+'&horaEmision='+hora, '_blank');
}

//Funcion que inicializa todos los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','');
	agregaFormatoControles('formaGenerica');
	
	$('#anioMes').val('');

	$('#clienteID').val('0');
	$('#nombreCliente').val('TODOS');
	
	$('#tipoEdoCta').val('0');

	$('#excel').attr("checked",true);
	deshabilitaBoton('generar', 'submit');
}	

//FUNCIÓN SOLO ENTEROS SIN PUNTOS NI CARACTERES ESPECIALES 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 37 || key > 37) && (key < 48 || key > 57)) //se valida, si son números o el caracter % los deja 
	    return false;
	 return true;
}
