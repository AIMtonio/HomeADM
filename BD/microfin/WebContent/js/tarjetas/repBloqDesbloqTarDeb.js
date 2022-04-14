var catTipoRepBloqDesBloqTarDeb = {	
		'PDF'		: 1			
};
var catListaTipoTar = {
	'activos' : 5
};
var parametroBean = consultaParametrosSession();

// funcion para llenar el combo de Tipos de Tarjeta

function llenaComboTiposTarjetasDeb() {
	var tarDebBean = {
			'tipoTarjeta' :'D',
			'tipoTarjetaDebID' : ''
	};
	dwr.util.removeAllOptions('tipoTarjetaDebID'); 		
	dwr.util.addOptions('tipoTarjetaDebID', {'':'TODOS'});
	tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tiposTarjetas){
		dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
	});
}

function llenaComboTiposTarjetasCred() {
	var tarDebBean = {
			'tipoTarjeta' :'C',
			'tipoTarjetaDebID' : ''
	};
	dwr.util.removeAllOptions('tipoTarjetaDebID'); 		
	dwr.util.addOptions('tipoTarjetaDebID', {'':'TODOS'});
	tipoTarjetaDebServicio.listaCombo(catListaTipoTar.activos, tarDebBean, function(tiposTarjetas){
		dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
	});
}
	

$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#fechaVencimiento').val(parametroBean.fechaSucursal);
  	$('#tipoTarjetaDeb').attr("checked",false);
  	$('#tipoTarjetaCred').attr("checked",false);
  	$('#tipoTarjetaDeb').focus();
	
	$('#pdf').attr("checked",true) ;

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
	   	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','clienteID');
		}
	});
	
	$('#clienteID').blur(function() {
		if($('#clienteID').val()!='') {
				consultaCliente($('#clienteID').val());
				$('#cuentaAhoID').val('');

		}
		else{
			$('#nombreCompleto').val('');
			limpiaCampos();
		}
	});

	$('#cuentaAhoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);	
	});

	
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#fechaRegistro').blur(function() {
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegistro').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaRegistro').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaRegistro').change(function() {
		var Xfecha= $('#fechaRegistro').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegistro').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimiento').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaRegistro').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').blur(function() {
		var Xfecha= $('#fechaRegistro').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaVencimiento').change(function() {
		var Xfecha= $('#fechaRegistro').val();
		var Yfecha= $('#fechaVencimiento').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimiento').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaVencimiento').val(Xfecha);
			}
		}else{
			$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		if($("#tipoTarjetaDeb").is(':checked')) {  
	           if($('#clienteID').val() > 0){
					camposLista[0] = "clienteID";
					parametrosLista[0] = $('#clienteID').val();
					listaAlfanumerica('cuentaAhoID', '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	
				}else{
					camposLista[0] = "clienteID";
					parametrosLista[0] = $('#cuentaAhoID').val();		
					listaAlfanumerica('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm'); 
				}
	        } 
	        else if($("#tipoTarjetaCred").is(':checked')){
	        	if($('#clienteID').val() > 0){
					camposLista[0] = "clienteID";
					parametrosLista[0] = $('#clienteID').val();
					listaAlfanumerica('cuentaAhoID', '1', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');	
				}else{
					camposLista[0] = "nomCompleto";
					parametrosLista[0] = $('#cuentaAhoID').val();		
					listaAlfanumerica('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm'); 
				}
	        }
	        else{  
	           mensajeSis("Selecciona el tipo de tarjeta");
	        } 
				 
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function consultaCliente(idControl) {
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(idControl != '' && !isNaN(idControl)){
			clienteServicio.consulta(conCliente,idControl,rfc,function(cliente){
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					var tipo = (cliente.tipoPersona);
					if(tipo=="F"){
						$('#nombreCompleto').val(cliente.nombreCompleto);
					}
					if(tipo=="M"){
						$('#nombreCompleto').val(cliente.razonSocial);
					}
					if(tipo=="A"){
						$('#nombreCompleto').val(cliente.nombreCompleto);
					}
				}else{
					alert("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();
					limpiaCampos();
				}    						
			});
		}
		else{
			$('#clienteID').val('');
			$('#cuentaAhoID').val('');

			$('#clienteID').focus();
			
		}
	}
	
	$('#formaGenerica').validate({
		rules: {
			fechaRegistro :{
				required: true
			},
			fechaVencimiento:{
				required: true
			}
		},
		messages: {
			fechaRegistro :{
				required: 'Especifica la Fecha de Inicio.'
			}
			,fechaVencimiento :{
				required: 'Especifica la Fecha Fin.'
			}
		}
	});

	$('#estatus').change(function() {
		var estatus1= $('#estatus').val();
		var numLista= 0;
		if ( estatus1==8 ){
			numLista=3;
			consultaCatalogoTarjeta(numLista);
		}
		else if ( estatus1==7) {
			numLista=4;
			consultaCatalogoTarjeta(numLista);
		}else{
			numLista=9;
			consultaCatalogoTarjeta(numLista);
		}
	});
	
	function consultaCatalogoTarjeta(numLista) {
		var numlista= numLista;
		if(numlista ==9){			
			dwr.util.removeAllOptions('motivoBloqID'); 
			dwr.util.addOptions('motivoBloqID', {'':'TODOS'});
		}else{
			dwr.util.removeAllOptions('motivoBloqID');
			dwr.util.addOptions('motivoBloqID', {'':'TODOS'});
			catalogoBloqueoCancelacionTarDebitoServicio.listaCombo( numlista, function(motivos){
				dwr.util.addOptions('motivoBloqID', motivos, 'motCanBloID', 'descripcion');
			});
		}
	}

	$('#generar').click(function() {
		var fechaRegistro = $("#fechaRegistro").val();
		var fechaVencimiento = $("#fechaVencimiento").val();
		if( fechaRegistro ==''){
			alert("La fecha Inicio está Vacia");
			$('#fechaRegistro').focus();
			 event.preventDefault();
		}else 
		
			if( fechaVencimiento ==''){
				alert("La fecha Fin está Vacia");
				$('#fechaVencimiento').focus();

				 event.preventDefault();
		}
		else{
			var tr= catTipoRepBloqDesBloqTarDeb.PDF;
			var  clienteID = 0;
			if($("#clienteID").asNumber()>0 ){
				 clienteID = $("#clienteID").asNumber();
			};
			var  cuentaAhoID = 0;
			if($("#cuentaAhoID").asNumber()>0 ){
				cuentaAhoID = $("#cuentaAhoID").asNumber();
			};
		
			var estatus = $("#estatus option:selected").val();
			var tipoTarjetaDebID = $("#tipoTarjetaDebID option:selected").val();
			var motivoBloqID = $("#motivoBloqID option:selected").val();
			
			
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
	
			
			/// VALORES TEXTO
			var nombreCompleto = $("#nombreCompleto ").val();
			var nombreTarjeta=$("#nombreTarjeta ").val();
			var nombreUsuario = parametroBean.claveUsuario; 
			var descriBloqueo=$("#descriBloqueo").val();	
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			
			if(motivoBloqID==''){
				motivoBloqID='0';
			}
		
			if(tipoTarjetaDebID==''){
				tipoTarjetaDebID='0';
			}
		
			if(nombreTarjeta=='0'){
				nombreTarjeta='';
			}
			else{
				nombreTarjeta = $("#tipoTarjetaDebID option:selected").html();
			}

			if(descriBloqueo=='0'){
				descriBloqueo='';
			}else{
				descriBloqueo = $("#motivoBloqID option:selected").html();
			}

			if ($("#tipoTarjetaDeb").is(':checked')){
				$('#ligaGenerar').attr('href','ReporteBloqDesbloqTarDeb.htm?'+'&fechaRegistro='+fechaRegistro+
					'&fechaVencimiento='+fechaVencimiento+'&estatus='+estatus+'&tipoTarjetaDebID='+tipoTarjetaDebID
					+'&motivoBloqID='+motivoBloqID+'&clienteID='+clienteID+'&cuentaAhoID='+cuentaAhoID+'&fechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nombreCompleto='+nombreCompleto+'&nombreTarjeta='+nombreTarjeta+	
					'&descriBloqueo='+descriBloqueo+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
			}
			else if ($("#tipoTarjetaCred").is(':checked')) {
				$('#ligaGenerar').attr('href','ReporteBloqDesbloqTarCred.htm?'+'&fechaRegistro='+fechaRegistro+
					'&fechaVencimiento='+fechaVencimiento+'&estatus='+estatus+'&tipoTarjetaID='+tipoTarjetaDebID
					+'&motivoBloqID='+motivoBloqID+'&clienteID='+clienteID+'&lineaTarCredID='+cuentaAhoID+'&fechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nombreCompleto='+nombreCompleto+'&nombreTarjeta='+nombreTarjeta+	
					'&descriBloqueo='+descriBloqueo+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion);
				
			}
						
			
		}
	});	
});






	function limpiaCampos() {
		$('#fechaRegistro').val(parametroBean.fechaSucursal);
		$('#fechaVencimiento').val(parametroBean.fechaSucursal);
		$('#fechaRegistro').focus();
		$('#clienteID').val('');
		$('#nombreCompleto').val('');
		$('#cuentaAhoID').val('');
		$('#tipoTarjetaDebID').val('');
		$('#motivoBloqID').val('');
		$('#estatus').val(0);
		

	}
	$('#tipoTarjetaDeb').click(function() {	
		limpiaCampos();
		$('#tipoTarjetaCred').attr("checked",false);
		$('#tipoTarjeta').val('1');
		$('#tarjetaID').focus();
		llenaComboTiposTarjetasDeb();		
	});
	$('#tipoTarjetaCred').click(function() {
		limpiaCampos();	
		$('#tipoTarjetaDeb').attr("checked",false);
		$('#tipoTarjeta').val('2');
		$('#tarjetaID').focus();
		llenaComboTiposTarjetasCred();		
	});





	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}

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