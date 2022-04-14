$(document).ready(function() {
	// Definicion de Constantes y Enums
	$("#fechaCargaInicial").focus();
	esTab = true;

	var parametroBean = consultaParametrosSession();   
	fechaHabilInicio('fechaCargaInicial',parametroBean.fechaSucursal);
	fechaHabilInicio('fechaCargaFinal',parametroBean.fechaSucursal);
	$('#promotorID').val(0);
	$('#nombrePromotorI').val('TODOS');
	$('#estadoID').val(0);
	$('#nombreEstado').val('TODOS');
	$('#municipioID').val(0);
	$('#nombreMuni').val('TODOS');
	
	
	var catTipoLisAnaliticoAhorro  = {
			'analiticoAhorroExcel'	: 1
	};	

	var catTipoRepAnaliticoAhorro = { 
			'PDF'		: 1,
			'Excel'		: 2
	};	
		
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	consultaSucursal();
	consultaMoneda(); 
	consultaTiposCuenta();
	
	$('#fechaCargaInicial').change(function() {
		var Xfecha= $('#fechaCargaInicial').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaCargaFinal').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaCargaInicial').val(parametroBean.fechaSucursal);
		}
	});

	// se valida que la fecha de carga no sea superior a la fecha del sistema
	$('#fechaCargaFinal').change(function() {
		var Xfecha= $('#fechaCargaInicial').val();
		var Yfecha= $('#fechaCargaFinal').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaCargaFinal').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaCargaFinal').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaCargaFinal').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#pdf').attr("checked",true) ; 



	$(':text').focus(function() {	
		esTab = false;
	});

	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});	



	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";


		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});


	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});
	
	 
	//------------ Validaciones de Controles -------------------------------------


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
							if(tipo=="A"){
								$('#nombreCliente').val(cliente.nombreCompleto);
							}		
						
						}else{
							alert("No Existe el Cliente");
							$(jqCliente).focus();
							$(jqCliente).select();
						
						}    						
				});
			}
	}	



	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotorI').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotorI').val(promotor.nombrePromotor); 

					}else{
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotorI').val('TODOS');
					}    	 						
				});
			}
	}


	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numEstado == '' || numEstado==0){
			$('#estadoID').val(0);
			$('#nombreEstado').val('TODOS');

			var municipio= $('#municipioID').val();
			if(municipio != '' && municipio!=0){
				$('#municipioID').val('');
				$('#nombreMuni').val('TODOS');
			}
		}
		else	
			if(numEstado != '' && !isNaN(numEstado) ){
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
					if(estado!=null){							
						$('#nombreEstado').val(estado.nombre);

						var municipio= $('#municipioID').val();
						if(municipio != '' && municipio!=0){
							consultaMunicipio('municipioID');
						}

					}else{
						alert("No Existe el Estado");
						$('#estadoID').val(0);
						$('#nombreEstado').val('TODOS');
					}    	 						
				});
			}
	}	



	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numMunicipio == '' || numMunicipio==0 || numEstado == '' || numEstado==0){

			if(numEstado == '' || numEstado==0 && numMunicipio!=0){
				alert("No ha selecionado ningún estado.");
				$('#estadoID').focus();
			}
			$('#municipioID').val(0);
			$('#nombreMuni').val('TODOS');
		}
		else	
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombreMuni').val(municipio.nombre);

					}else{
						alert("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMuni').val('TODOS');
					}    	 						
				});
			}
	}	

	// fin validacion Promotor, Estado, Municipio



	function consultaSucursal(){
		var tipoCon=2;
		dwr.util.removeAllOptions('sucursal');
		dwr.util.addOptions( 'sucursal', {'':'SELECCIONAR'});
		dwr.util.addOptions( 'sucursal', {'0':'TODOS'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursal', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});



	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'':'SELECCIONAR'});
		dwr.util.addOptions( 'monedaID', {'0':'TODOS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function consultaTiposCuenta() {
  		dwr.util.removeAllOptions('tipoCuentaID');
  		dwr.util.addOptions('tipoCuentaID', {'':'SELECCIONAR'}); 
		dwr.util.addOptions('tipoCuentaID', {0:'TODOS'}); 
//		var bean={};
//		tiposCuentaServicio.listaCombo(2, bean, function(tiposCuenta){
		tiposCuentaServicio.listaCombo(6, function(tiposCuenta){
		dwr.util.addOptions('tipoCuentaID', tiposCuenta, 'tipoCuentaID', 'descripcion');
		});
	}

	


	function generaExcel() {
		
		$('#pdf').attr("checked",false) ;
		
		if($('#excel').is(':checked')){	
			var tr= catTipoRepAnaliticoAhorro.Excel; 
			var tl= catTipoLisAnaliticoAhorro .analiticoAhorroExcel;  
			var estado = $('#estadoID').val();
			var municipio = $('#municipioID').val();
			var promotor = $('#promotorID').val();
			
			if (estado == '' || isNaN(estado)){
				estado = 0;
			}
			
			if (municipio == '' || isNaN(municipio)){
				municipio = 0;
			}
			
			if (promotor == '' || isNaN(promotor)){
				promotor = 0;
			}
			
			$('#ligaGenerar').attr('href','reporteMovCuentas.htm?'+
					'&fechaInicial='	+$('#fechaCargaInicial').val()+
					'&fechaFinal='		+$('#fechaCargaFinal').val()+
					'&mostrar='			+$('#mostrar').val()+
					'&detMostrar='		+$('#mostrar  option:selected').html()+
					'&tipoCuenta='		+$("#tipoCuentaID option:selected").val()+
					'&detTipoCuenta='	+$('#tipoCuentaID  option:selected').html()+
					'&sucursal='		+$("#sucursal option:selected").val()+
					'&detSucursal='		+$('#sucursal  option:selected').html()+
					'&moneda='			+$("#monedaID option:selected").val()+
					'&detMoneda='		+$('#monedaID  option:selected').html()+
					'&promotor='		+promotor+
					'&detPromotor='		+$('#nombrePromotorI').val()+
					'&genero='			+$("#sexo option:selected").val()+
					'&detGenero='		+$('#sexo  option:selected').html()+
					'&estado='			+estado+
					'&detEstado='		+$('#nombreEstado').val()+
					'&municipio='		+municipio+
					'&detMunicipio='	+$('#nombreMuni').val()+
					'&fechaActual='		+parametroBean.fechaAplicacion+
					'&claveUsuario='	+parametroBean.claveUsuario+
					'&nomInstitucion='	+parametroBean.nombreInstitucion+
					'&tipoReporte='		+tr+
					'&tipoLista='		+tl
					
			);
		
		}
	}
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tr= catTipoRepAnaliticoAhorro.PDF; 
			var estado = $('#estadoID').val();
			var municipio = $('#municipioID').val();
			var promotor = $('#promotorID').val();
			
			if (estado == '' || isNaN(estado)){
				estado = 0;
			}
			
			if (municipio == '' || isNaN(municipio)){
				municipio = 0;
			}
			
			if (promotor == '' || isNaN(promotor)){
				promotor = 0;
			}
			
	$('#ligaGenerar').attr('href','reporteMovCuentas.htm?'+
			'&fechaInicial='	+$('#fechaCargaInicial').val()+
			'&fechaFinal='		+$('#fechaCargaFinal').val()+
			'&mostrar='			+$('#mostrar').val()+
			'&detMostrar='		+$('#mostrar  option:selected').html()+
			'&tipoCuenta='		+$("#tipoCuentaID option:selected").val()+
			'&detTipoCuenta='	+$('#tipoCuentaID  option:selected').html()+
			'&sucursal='		+$("#sucursal option:selected").val()+
			'&detSucursal='		+$('#sucursal  option:selected').html()+
			'&moneda='			+$("#monedaID option:selected").val()+
			'&detMoneda='		+$('#monedaID  option:selected').html()+
			'&promotor='		+promotor+
			'&detPromotor='		+$('#nombrePromotorI').val()+
			'&genero='			+$("#sexo option:selected").val()+
			'&detGenero='		+$('#sexo  option:selected').html()+
			'&estado='			+estado+
			'&detEstado='		+$('#nombreEstado').val()+
			'&municipio='		+municipio+
			'&detMunicipio='	+$('#nombreMuni').val()+
			'&fechaActual='		+parametroBean.fechaAplicacion+
			'&claveUsuario='	+parametroBean.claveUsuario+
			'&nomInstitucion='	+parametroBean.nombreInstitucion+
			'&tipoReporte='		+tr);
			

		}
	}


function validarFecha(idcontrol){
		
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var anioFechaSucursal	= valorFechaSucursal.substr(0,4);
		var mesFechaSucursal = valorFechaSucursal.substr(5,2);
		var diaFechaSucursal = valorFechaSucursal.substr(8,2);

		var jqvalorFechaCarga	= eval("'#"+idcontrol+"'");
		var valorFechaCarga 	= $(jqvalorFechaCarga).val();
		if(valorFechaCarga == null || valorFechaCarga == ''){
			return;
		}
		var anioFechaCarga	= valorFechaCarga.substr(0,4);
		var mesFechaCarga = valorFechaCarga.substr(5,2);
		var diaFechaCarga = valorFechaCarga.substr(8,2);
		var separadorUnoFechaCarga = valorFechaCarga.substr(4,1);
		var separadorDosFechaCarga = valorFechaCarga.substr(7,1);

		if(separadorUnoFechaCarga == "-"){
			if(separadorDosFechaCarga == "-"){
				if(anioFechaCarga>anioFechaSucursal){  
					alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
					$(jqvalorFechaCarga).focus().select();
					fechaHabilInicio(idcontrol,valorFechaSucursal);
				}else{
					if(anioFechaCarga==anioFechaSucursal){ 
						if(mesFechaCarga>mesFechaSucursal){ 
							alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
							$(jqvalorFechaCarga).focus().select();
							fechaHabilInicio(idcontrol,valorFechaSucursal);
						}else{
							if(mesFechaCarga==mesFechaSucursal){
								if(diaFechaCarga>diaFechaSucursal){
									alert("La fecha de Carga no puede ser superior \n a la fecha del sistema.");
									$(jqvalorFechaCarga).focus().select();
									fechaHabilInicio(idcontrol,valorFechaSucursal);	        
								}
							}
						}	
					}
				}
			}else{
				alert("Formato de fecha incorrecto 'aaaa-mm-dd'");
				$(jqvalorFechaCarga).focus().select();
				fechaHabilInicio(idcontrol,valorFechaSucursal);
			}
		}else{
			alert("Formato de fecha incorrecto 'aaaa-mm-dd'");
			$(jqvalorFechaCarga).focus().select();
			fechaHabilInicio(idcontrol,valorFechaSucursal);
		}

	}
	function comparaFechas(idControl,fechaIni,fechaFin){
		var jqControl = eval("'#"+idControl+"'");
		var valorFechaSucursal = parametroBean.fechaSucursal;
		var xYear=fechaIni.substring(0,4);
		var xMonth=fechaIni.substring(5, 7);
		var xDay=fechaIni.substring(8, 10);
		var yYear=fechaFin.substring(0,4);
		var yMonth=fechaFin.substring(5, 7);
		var yDay=fechaFin.substring(8, 10);
		if (yYear<xYear ){
    		alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
    		fechaHabilInicio(idControl,valorFechaSucursal);
    		$(jqControl).focus().select();
    		return false;
		}else{
			if (xYear == yYear){
				if (yMonth<xMonth){
					
					alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
					fechaHabilInicio(idControl,valorFechaSucursal);
					$(jqControl).focus().select();
		    		return false;
				}else{
					if (xMonth == yMonth){
						if (yDay<xDay){
							alert("La Fecha Final debe ser Mayor a la Fecha Inicial.");
							fechaHabilInicio(idControl,valorFechaSucursal);
							$(jqControl).focus().select();
	    		    		return false;

						}
					}
				}
			}
		}
	return true;
    }
	function fechaHabilInicio(idcontrol,fecha){
		// solo la fecha del sistema
		var jqControl = eval("'#"+idcontrol+"'");
		$(jqControl).val(parametroBean.fechaSucursal);

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


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
});