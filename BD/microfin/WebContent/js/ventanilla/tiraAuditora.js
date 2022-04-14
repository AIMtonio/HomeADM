$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	  var tipo= parametros.tipoImpTicket;
	    var ticket= 'T';
	    var impresoraTicket=parametroBean.impTicket;
	//deshabilitaBoton('generar', 'submit');
	var catTipoListaMoneda = {
		'principal': 3
	};

	var catTipoListaSucursal = {
		'combo': 2
	};
	var catTipoListaTira = {
		'arqueoCaja': 3
	};
	var catTipoListaTiraHis = {
		'arqueoCajaHis': 7
		};
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	cargaSucursales();
	cargaMonedas();
	var parHora = hora();
	$('#hora').val(parHora);
	agregaFormatoControles('formaGenerica');
	//------------ Metodos y Manejo de Eventos ----------
	$('#fecha').val(parametros.fechaSucursal);
	if (parametros.cajaID == 0){
		var fechaSucursal = parametros.fechaSucursal;
		var fecha = fechaSucursal.split("-");
		var anio = fecha[0];
		anio = anio.substring(2, 4);
		var mes = fecha[1];
		var dia = fecha[2];
		$('#fecha').datepicker('option', 'maxDate', anio+'-'+mes+'-'+dia);
	}else{
		$('#sucursalID').hide();
		$('#nomSucursal').show();
		$('#nomSucursal').val(parametros.nombreSucursal);
		$('#sucursalID').attr('disabled', 'true');
		$('#cajaID').attr('disabled', 'true');
		$('#fecha').datepicker('option', 'maxDate', null);
		$('#cajaID').val(parametros.cajaID);
		consultaCaja("cajaID");
	}
	$('#fecha').change(function (){
		if (this.value != ''){
			habilitaBoton('generar', 'submit','generar');
		}
		if($('#fecha').val().length >= 10 ){
			
		if (FechaValida($('#fecha').val())) {
		    $('#fecha').val(parametros.fechaSucursal);
		    $('#fecha').focus();
		    $('#fecha').select();
		    return  consultaGridMovimientos();;
		    
		    
		}
		if  ($('#fecha').val()==FechaValida){
			$('#consultar');
		}
		if ($('#fecha').val()== parametros.fechaSucursal){
			  consultaGridMovimientos();
		}else{consultaGridMovimientosHis();
		}

		
		if (parametros.cajaID != 0){
			$('#sucursalID').val(parametros.sucursal);
		}
		}
	});
	
	$('#cajaID').blur(function() {
  		consultaCaja(this.id);
  		$('#monedaID').val(1);
	});		
	
	$('#cajaID').bind('keyup',function(e) {
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cajaID";
			camposLista[1] = "sucursalID";
			parametrosLista[0] = $('#cajaID').val();
			parametrosLista[1] = $('#sucursalID').val();
			lista('cajaID', '1', '1', camposLista, parametrosLista, 'listaCajaVentanilla.htm');
		}
	});

	
	$('#generar').click(function() {
		  	quitaFormatoControles('formaGenerica');
			var tipoReporte	= 2;
			var nombreInst		= parametros.nombreInstitucion;	
			var sucursalID		= completaCerosIzq($('#sucursalID').val(),3);
			var nomSucursal 	= $('#sucursalID option:selected').text();
			var cajaID 			= completaCerosIzq($('#cajaID').val(),3);
			var numUsuario		= completaCerosIzq(parametros.numeroUsuario,3);
			var nomUsuario		= parametros.claveUsuario;
			var fecha 			= $('#fecha').val();
			var hora	 		=  $('#hora').val();
			applet.findPrinter(impresoraTicket);
			if(tipo !=ticket){	
				window.open('ReporteTiraAuditora.htm?programaID='+nombreInst+'&sucursalID='+sucursalID+'&sucursal='+nomSucursal+'&cajaID='+cajaID+
						'&usuarioID='+numUsuario+'&usuario='+nomUsuario+'&fecha='+fecha+'&fechaActual='+hora+"&tipoReporte="+tipoReporte);
			}else
				if ($('#fecha').val()== parametros.fechaSucursal){
				generaTicketTiraAuditora();
				
			}else{generaTicketTiraAuditoraHis();
			}
		
	});
	$('#pdf').click(function() {
	  	quitaFormatoControles('formaGenerica');
		var tipoReporte	= 2;
		var nombreInst		= parametros.nombreInstitucion;	
		var sucursalID		= completaCerosIzq($('#sucursalID').val(),3);
		var nomSucursal 	= $('#sucursalID option:selected').text();
		var cajaID 			= completaCerosIzq($('#cajaID').val(),3);
		var numUsuario		= completaCerosIzq(parametros.numeroUsuario,3);
		var nomUsuario		= parametros.claveUsuario;
		var fecha 			= $('#fecha').val();
		var hora	 		=  $('#hora').val();
		
		if  ($('#fecha').val()== parametros.fechaSucursal){
			window.open('ReporteTiraAuditora.htm?programaID='+nombreInst+'&sucursalID='+sucursalID+'&sucursal='+nomSucursal+'&cajaID='+cajaID+
					'&usuarioID='+numUsuario+'&usuario='+nomUsuario+'&fecha='+fecha+'&fechaActual='+hora+"&tipoReporte="+tipoReporte);	
		}else{
			window.open('ReporteTiraAuditoraHis.htm?programaID='+nombreInst+'&sucursalID='+sucursalID+'&sucursal='+nomSucursal+'&cajaID='+cajaID+
					'&usuarioID='+numUsuario+'&usuario='+nomUsuario+'&fecha='+fecha+'&fechaActual='+hora+"&tipoReporte="+tipoReporte);	
	             }
	});

	$('#sucursalID').change(function (){
		$('#monedaID').val(1);
	});
	
	$('#consultar').click(function(){
		if ($('#fecha').val()== parametros.fechaSucursal){
			  consultaGridMovimientos();
		}else{consultaGridMovimientosHis();
		}


		$('#nombreInstitucion').val(parametros.nombreInstitucion);
		$('#numUsuario').val(parametros.numeroUsuario);
		$('#nomUsuario').val(parametros.claveUsuario);
	});

	$('#formaGenerica').validate({				
		rules: {
			fecha: {
				required: true
			},
			sucursalID: {
				required: true
			},			
			monedaID: {
				required: true
			},
			cajaID: {
				required: true
			}
			
		},		
		messages: {
			fecha: {
				required: 'Especifique Fecha'
			},
			sucursalID : {
				required: 'Especifique Sucursal'
			},			
			
			monedaID: {
				required: 'Especifique Moneda'
			},
			cajaID: {
				required: 'Especifique Numero de Caja'
			}
		}		
	});


	function generaTicketTiraAuditora() {	


			var bean = {
			'sucursalID':$('#sucursalIDSesion').val(),
			'cajaID':$('#cajaIDSesion').val(),
			'fecha':$('#fecha').val()
		};


		cajasVentanillaServicio.listaTicketVentanilla(1, bean, function(tirAuditoraRes){
        
			if(tirAuditoraRes!=null){
				for (var i = 0; i < tirAuditoraRes.length; i++){
					if((i+1)==tirAuditoraRes.length ){
             
						imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta,'S' ,'N');
					}else{
						if(i==0 ){
					
							imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta, 'N','S');
						}else{
						
							imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta, 'N','N');
						}
					}
				}
			}
		});
	}
			
	function generaTicketTiraAuditoraHis() {	


		var bean = {
		'sucursalID':$('#sucursalIDSesion').val(),
		'cajaID':$('#cajaIDSesion').val(),
		'fecha':$('#fecha').val()
	};


	cajasVentanillaServicio.listaTicketVentanilla(4, bean, function(tirAuditoraRes){
    
		if(tirAuditoraRes!=null){
			for (var i = 0; i < tirAuditoraRes.length; i++){
				if((i+1)==tirAuditoraRes.length ){
         
					imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta,'S' ,'N');
				}else{
					if(i==0 ){
				
						imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta, 'N','S');
					}else{
					
						imprimeTicketTiraAuditora(tirAuditoraRes[i].descCorta, 'N','N');
					}
				}
			}
		}
	});
}
		
	


	function cargaMonedas(){
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'Todas'});
		monedasServicio.listaCombo(catTipoListaMoneda.principal, function(monedas){
			//dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			for (var i = 0; i < monedas.length; i++){
				$('#monedaID').append(new Option(monedas[i].descripcion, parseInt(monedas[i].monedaID), false, false));
			}
			$('#monedaID').val(1);
		});
	}
 	
 	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Todas'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
 	}
 	
	function consultaCaja(idControl){
		var jqCajaVentanilla = eval("'#" + idControl + "'");
		var numCajaID = $(jqCajaVentanilla).val();
		var conPrincipal = 1;
		var CajasVentanillaBeanCon = {
  			'cajaID': numCajaID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCajaID != '' && !isNaN(numCajaID)){
			cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
				if(cajasVentanilla != null){
					$('#descripcionCaja').val(cajasVentanilla.tipoCaja);
					$('#sucursalID').val(cajasVentanilla.sucursalID);
					if(parametros.cajaID == 0){
						habilitaBoton('generar','submit','generar');
					}
				}
				else{
					alert("No Existe la Caja.");
					$('#cajaID').focus();
					$('#cajaID').val('');
					$('#descripcionCaja').val("");
					deshabilitaBoton('generar','submit','generar');
				}
			});
		}
	}
	
	function completaCerosIzq(obj,longitud) {
		var numtmp= String(obj);
  		while (numtmp.length<longitud){  		
    		numtmp = '0'+numtmp;
		}
		return numtmp;
	}
	
	function hora(){	
		 var Digital=new Date();
		 var hours=Digital.getHours();
		 var minutes=Digital.getMinutes();
		 var seconds=Digital.getSeconds();
		 if (minutes<=9)
		 minutes="0"+minutes;
		 if (seconds<=9)
		 seconds="0"+seconds;
		return  hours+":"+minutes;
	 }
	
	function consultaGridMovimientos(){
 		var sucursalID = parametros.sucursal;
 		var cajaID = $('#cajaID').val();
 		var fecha = parametros.fechaSucursal;

 		var params = {
			'tipoLista'  : catTipoListaTira.arqueoCaja,
 			'sucursalID' : sucursalID,
 			'cajaID' 	 : cajaID,
 			'fecha' 	 : fecha,
 			'naturaleza'	: 1
		};
		
		$.post("tiraAuditoraGridVista.htm", params,  function(data){
			$('#gridMovimientos').show();
				if(data.length >0) {
					$('#gridDetalleMovsEntrada').html(data);
					var params = {
							'tipoLista'  : catTipoListaTira.arqueoCaja,
				 			'sucursalID' : sucursalID,
				 			'cajaID' 	 : cajaID,
				 			'fecha' 	 : fecha,
				 			'naturaleza'	: 2
					};
					
					
					$.post("tiraAuditoraGridVista.htm", params,  function(data){
						if(data.length >0) {
							$('#gridDetalleMovsSalida').html(data);
						}else{
							$('#gridDetalleMovsSalida').html("");
						}
					});
				}else{
					$('#gridDetalleMovsEntrada').html("");
				}
		});
	}
	function consultaGridMovimientosHis(){
 		var sucursalID = parametros.sucursal;
 		var cajaID = $('#cajaID').val();
    	var fecha =$('#fecha').val();

 		var bean = {
			'tipoLista'  : 7,
 			'sucursalID' : sucursalID,
 			'cajaID' 	 : cajaID,
 			'fecha' 	 : fecha,
 			'naturaleza'	: 1,
 	
 			
		};

 		$.post("tiraAuditoraGridVista.htm", bean,  function(data){
			$('#gridMovimientos').show();
				if(data.length >0) {
					$('#gridDetalleMovsEntrada').html(data);
					var bean = {
							'tipoLista'  : 7,
				 			'sucursalID' : sucursalID,
				 			'cajaID' 	 : cajaID,
				 			'fecha' 	 : fecha,
				 			'naturaleza'	: 2,
			
					};
					
					
					$.post("tiraAuditoraGridVista.htm", bean,  function(data){
						if(data.length >0) {
							$('#gridDetalleMovsSalida').html(data);
						}else{
							$('#gridDetalleMovsSalida').html("");
						}
					});
				}else{
					$('#gridDetalleMovsEntrada').html("");
				}
		});
	}
	
	
}); // cerrar

function FechaValida(fecha){
	
	var fecha2 = parametros.fechaSucursal;
	if(fecha == ""){return false;}
	if (fecha != undefined  ){
		
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			alert("formato de fecha no válido (aaaa-mm-dd)");
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


parametros = consultaParametrosSession();
var tipo= parametros.tipoImpTicket;
  var ticket= 'T';


function muestra_oculta(id){
	if (document.getElementById){
		var el = document.getElementById(id);
		el.style.display = (el.style.display == 'none') ? 'block' : 'none';
	}
}

function impTicketDetalle(valor){
	var estatus;	
	if(tipo !=ticket){	
		if ( valor== 16 ||valor== 42 ){
			if ( valor==16){
				estatus = 'E'; 
			}else{
				estatus = 'R';
			}
					
			printWin=windows.open('RepDetalleArqueoTransferCaja.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
					'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
					'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
					'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
					'&hora='+$('#hora').val()+'&numOperacion='+valor+'&estatus='+estatus);
				

				
		}else{
				
			printWin=window.open('RepDetalleArqueoCaja.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
				'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
				'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
				'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
				'&hora='+$('#hora').val()+'&numOperacion='+valor);
			
		
		}

	}else{
		consultaDetalleTira(valor);
	}

}

function impTicketDetalleHis(valor){
	var estatus;
	if(tipo !=ticket){	
		if ( valor== 42 ||valor== 16){
			if ( valor==42){
				estatus = 'E'; 
			}else {
				estatus = 'R';
			}
		
			printWin=window.open('RepDetalleArqueoTransferCajaHis.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
					'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
					'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
					'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
					'&hora='+$('#hora').val()+'&numOperacion='+valor+'&estatus='+estatus);
			
		}else{
			printWin=window.open('RepDetalleArqueoCajaHis.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
				'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
				'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
				'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
				'&hora='+$('#hora').val()+'&numOperacion='+valor);
			}
		
		}else {consultaDetalleTiraHis(valor);
		}

}

function consultaDetalleTira(valor) {	


	var bean = {
	'sucursalID':$('#sucursalID').val(),
	'cajaID':$('#cajaID').val(),
	'fecha':$('#fecha').val(),
	'tipoOperacion':valor
};
         cajasVentanillaServicio.listaTicketVentanilla(2, bean, function(imp){
    
		if(imp!=null){
			for (var i = 0; i < imp.length; i++){
				if((i+1)==imp.length ){
         				
					impTicketDetalleTira(imp[i].descCorta,'S','N');
				}else{
					if(i==0 ){
						
					impTicketDetalleTira(imp[i].descCorta, 'N','S');
	
						}else{
						
					imprimeTicketTiraAuditora(imp[i].descCorta, 'N','N');
				
				}
			
			}
		}
	  }
	});

}
function consultaDetalleTiraHis(valor) {	


	var bean = {
	'sucursalID':$('#sucursalID').val(),
	'cajaID':$('#cajaID').val(),
	'fecha':$('#fecha').val(),
	'tipoOperacion':valor
};
         cajasVentanillaServicio.listaTicketVentanilla(3, bean, function(impr){
    
		if(impr!=null){
			for (var i = 0; i < impr.length; i++){
				if((i+1)==impr.length ){
         				
					impTicketDetalleTira(impr[i].descCorta,'S','N');
				}else{
					if(i==0 ){
						
					impTicketDetalleTira(impr[i].descCorta, 'N','S');
	
						}else{
						
					imprimeTicketTiraAuditora(impr[i].descCorta, 'N','N');
				
				}
			
			}
		}
	  }
	});

}
// funcion que genera detalle segun fecha en el ticket 
function EscojeTicketHis(valor){
	if ($('#fecha').val()== parametros.fechaSucursal){
		  impTicketDetalle(valor);
	}else{  impTicketDetalleHis(valor);
	}
}
function generaDetalle(valor){
	var tipoReporte = 2;
	var estatus;
	
		if ( valor== 42 ||valor== 16 ||valor== 41 ||valor== 36 ){
		if ( valor==36||valor==42){
				estatus = 'E'; 
			}else {
				estatus = 'R';
			}
		
			printWin=window.open('RepDetalleArqueoTransferCaja.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
					'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
					'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
					'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
					'&hora='+$('#hora').val()+'&numOperacion='+valor+'&estatus='+estatus+'&tipoReporte='+tipoReporte);
			
		}
		else{
			printWin=window.open('RepDetalleArqueoCaja.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
				'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
				'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
				'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
				'&hora='+$('#hora').val()+'&numOperacion='+valor+'&tipoReporte='+tipoReporte);
	
		
		}
}

function generaDetalleHis(valor){
var tipoReporte = 2;
	var estatus;
	if ( valor== 42 ||valor== 16 ||valor== 41 ||valor== 36 ){
		if ( valor==36||valor==42){
			estatus = 'E'; 
		}else {
			estatus = 'R';
		}
	

	printWin=window.open('RepDetalleArqueoTransferCajaHis.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
			'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
			'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
			'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
			'&hora='+$('#hora').val()+'&numOperacion='+valor+'&estatus='+estatus+'&tipoReporte='+tipoReporte);
	
}
	else{
		printWin=window.open('RepDetalleArqueoCajaHis.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
			'&numeroSucursal='+$('#sucursalID').val()+'&nombreSucursal='+$('#nomSucursal').val()+
			'&numCaja='+$('#cajaID').val()+'&numUsuario='+$('#numUsuario').val()+
			'&nomUsuario='+$('#nomUsuario').val()+'&fechaSistema='+$('#fecha').val()+
			'&hora='+$('#hora').val()+'&numOperacion='+valor+'&tipoReporte='+tipoReporte);

	
	}



}
// funcion que genera detalle segun fecha 
function EscogeDetalle(valor){
	if ($('#fecha').val()== parametros.fechaSucursal){
		generaDetalle(valor);
	}else{generaDetalleHis(valor);
	}
}
	
	