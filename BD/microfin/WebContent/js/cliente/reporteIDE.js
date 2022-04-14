	var tipoLista;
$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = false;

	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	$('#tipoReporte').focus();	
	iniciaValores();
	llenaComboAnios(parametroBean.fechaAplicacion);

	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$('#formaGenerica').validate({
		rules: {
			numeroEjercicio :{
				required: true
			},
			periodo:{
				required: true
			},
			clienteID :{
				required: true
			},
			sucursal:{
				required: true
			}				
		},
		
		messages: {
			numeroEjercicio :{
				required: 'Especifique Ejercicio.'
			},
			periodo :{
				required: 'Especifique Periodo.'
			},
			clienteID :{
				required: 'Especifique Cliente.'
			},
			sucursal :{
				required: 'Especifique Sucursal.'
			}
		}
	});

	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		if(this.value=='0'){
			$('#nombreCliente').val('TODOS');
		}else{
			consultaCliente(this.id);
		}
		
	});

	$('#sucursal').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursal', '2', '4', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});

	$('#sucursal').blur(function() {
		if($('#sucursal').val()==""){
			$('#sucursal').val(parametroBean.sucursal);
			consultaSucursal();
		} if($('#sucursal').val()=="0"){
			$('#sucursal').val("0");
			$('#nomSucursal').val("TODAS");
		}
		else{
			consultaSucursal();
		}
	});

	$('#periodo').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#ejercicio').val();
	   
	   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   $("#periodo option[value="+ mesSistema +"]").attr("selected",true);
		   this.focus();
	   }
	});

	$('#ejercicio').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#ejercicio').val();
	   var mesSeleccionado 	= $('#periodo').val();
	   
	   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Año Indicado es Incorrecto.");
		   $("#periodo option[value="+ mesSistema +"]").attr("selected",true);
		   this.focus();
	   }
	});

	$('#generar').click(function() { 
		if($('#tipoReporte').val()==""){
			mensajeSis("Seleccione un Tipo de Reporte.");
			$('#tipoReporte').focus();
		}else {
			if($('#excel').is(":checked") ){
					tipoLista=1;			
			}
			if($('#xml').is(":checked") ){	
				tipoLista=2;		
			}
			generaReporte();
		}	
		
	});

	$('#tipoReporte').click(function() { 
		if($('#tipoReporte').val()=="A" ){			
			$('#divPeriodo').hide();
		}else{
			$('#divPeriodo').show();
		}
	});


});

	//Consulta el Nombre de La Sucursal 
	function consultaSucursal() {
		var principal=1;
		numSucursal=$('#sucursal').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(principal,numSucursal,function(sucursal) { 
				if(sucursal!=null){
						$('#nomSucursal').val(sucursal.nombreSucurs);

				}else{
					mensajeSis("No Existe la Sucursal");
					$('#sucursal').focus();
					$('#sucursal').val(parametroBean.sucursal);
					consultaSucursal();
				} 
			});
		}
	}	
	
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
				if(cliente!=null){		
					$('#clienteID').val(cliente.numero);
					var tipo = (cliente.tipoPersona);
					if(tipo=="F"){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo=="M"){
						$('#nombreCliente').val(cliente.razonSocial);
					}		
        		
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').val('');
					$('#clienteID').focus();
				}    						
			});
		}else {
			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
		}
	}	

	function llenaComboAnios(fechaActual){
	   var anioActual 	= fechaActual.substring(0, 4);
	   var mesActual 	= parseInt(fechaActual.substring(5, 7));
	   var numOption 	= 4;
	  
	   for(var i=0; i<numOption; i++){
		   $("#ejercicio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }
	   
	   $("#periodo option[value="+ mesActual +"]").attr("selected",true);
	}

	function generaReporte(){	

			var fechaReporte = parametroBean.fechaAplicacion;		
			var tipoReporte  = $('#tipoReporte').val();	
			var ejercicio 	 = $('#ejercicio').val();
			var periodo 	 = $('#periodo').val(); 			
			var clienteID 	 = $('#clienteID').val();
			var sucursal 	 = $('#sucursal').val();
			var usuario 	 = parametroBean.claveUsuario;
		
			/// VALORES TEXTO
			var nombreCliente = $('#nombreCliente').val();
			var nombreSucursal = $('#nomSucursal').val();
			var nombreUsuario = parametroBean.claveUsuario; 			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var fechaEmision=parametroBean.fechaSucursal;
			var rfcIns = parametroBean.rfcInst;
			var rfcRep=parametroBean.rfcRepresentante;
			var representanteLegal=parametroBean.representanteLegal;
			var fechaCorte = generarFecha();
			var hora='';
			var horaEmision= new Date();
			hora = horaEmision.getHours();
			hora = hora+':'+horaEmision.getMinutes();
			hora = hora+':'+horaEmision.getSeconds();

			if(nombreSucursal=='0'){
				nombreSucursal='';
			}
			else{
				nombreSucursal = $('#nomSucursal').val();
			}

			var paginaReporte= 'IDERep.htm?tipoReporte='+tipoReporte+'&clienteID='+clienteID+'&sucursal='+sucursal+
			'&nombreSucursal='+nombreSucursal+'&usuario='+usuario+'&nombreUsuario='+nombreUsuario+'&nombreInstitucion='
			+nombreInstitucion+'&fechaEmision='+fechaEmision+'&horaEmision='+hora+'&tipoLista='+tipoLista+'&ejercicio='+ejercicio+
			'&periodo='+periodo+'&fechaReporte='+fechaReporte+'&rfcIns='+rfcIns+'&rfcRep='+rfcRep+'&representanteLegal='+representanteLegal
			+'&fechaCorte='+fechaCorte;			
			window.open(paginaReporte);
	}

	function iniciaValores(){
		$('#clienteID').val('0');
		$('#nombreCliente').val('TODOS');
		$('#sucursal').val('0');
		$('#nomSucursal').val('TODAS');
		$('#tipoReporte').val('M');
	}

function generarFecha(){
	var anio 	 = $('#ejercicio').val();
	var mes 	 = $('#periodo').val(); 
	var dia;

	if( mes==1 || mes==3 || mes==5 || mes==7 || mes==8 || mes==10 || mes==12){		
				dia=31;
	}else if(mes==4 || mes==6 || mes==9 || mes==11){
				dia=30; 
	}else if(mes==2){
		if(comprobarSiBisisesto(anio)){
			dia=29;
		}else{
			
			dia=28;
		}
	}	
			
	mes<10? mes=('0'+mes):mes;
	fechaCompleta=anio+"-"+mes+"-"+dia;
	return fechaCompleta;
}

function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "" && fecha.length == 8) {
		
		var mes = fecha.substring(4, 6) * 1;
		var dia = fecha.substring(6, 8) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			mensajeSis("Formato de Fecha Invalido.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Formato de Fecha Invalido.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}else{
		if(fecha != undefined && fecha != "" && fecha.length < 8){
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		}
		
	}
}

function comprobarSiBisisesto(anio) {
	var enteroCero=0;
	
	if ((anio % 100 != enteroCero) && ((anio % 4 == enteroCero) || (anio % 400 == enteroCero))) {
		return true;
	} else {
		return false;
	}
}
	