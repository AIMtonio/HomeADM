$(document).ready(function(){
	// Definicion de Constantes y Enums
	esTab = true;
	var tipoReporte = '';
	var parametroBean = consultaParametrosSession();	

	var catTipoConsultaTipoCede = {
		'principal':1,
		'general' : 2
	};

	var catTipoListaTipoCede = {
		'principal':1,
		'sucursal' :4
	};
	
	var catTipoConsultaCedes = {
	    'principalSucursal' : 1,
		'general' : 2,
	};
 
	var catTipoReporte = { 
		'pdf'		: 1,
		'excel'		: 2 
	};
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
		
	iniciaPantalla();

	$('#pdf').attr("checked",true);
	$('#excel').attr("checked",false);
	$('#tipoCedeID').focus();
	
    $('#sucursalID').bind('keyup',function(e){
    	lista('sucursalID', '2', catTipoListaTipoCede.sucursal, 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

    $('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
			
	$('#tipoCedeID').bind('keyup',function(e){
		lista('tipoCedeID', 2, catTipoListaTipoCede.principal, 'descripcion',   $('#tipoCedeID').val(), 'listaTiposCedes.htm');
	});

	$('#tipoCedeID').blur(function() {
		consultaTipoCede($('#tipoCedeID').val());
	});
	
	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor',$('#promotorID').val(), 'listaPromotores.htm');
	});

	$('#promotorID').blur(function(){
		consultaPromotor(this.id);
	});
	
	$('#formaGenerica').validate({
		rules:{
			fechaReporte:{
				required : true
			},
			tiposCedes:{
				required: true
			},
			promotorID:{
				required: true
			},
			sucursalID:{
				required: true
			},
			clienteID:{
				required: true
			}
		},
		messages:{
			fechaReporte:{
				required: 'Especifique Fecha de Reporte'
			},
			tiposCedes:{	
				required: 'Especifique un Tipo de Cede'
			},
			promotorID:{
				required: 'Especifique un Promotor'
			},
			sucursalID:{
				required:'Especifique una Sucursal'
			},
			clienteID:{
				required:'Especifique un ' + $('#socioCliente').val()
			}
		}
		
	});
	
	$('#clienteID').bind('keyup',function(e){
		var promotorID =  $('#promotorID').val();
		var sucursalID =  $('#sucursalID').val();
		
		var camposLista = new Array();		
		var parametrosLista = new Array();		
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		
		if(!isNaN(promotorID) && promotorID!=''){
			if(parseFloat(promotorID)>0){
				camposLista[1] = "sucursalID";
				parametrosLista[1] = $('#promotorID').val();
				lista('clienteID', '2', '36', camposLista, parametrosLista, 'listaCliente.htm');
			}else{
				if(parseFloat(sucursalID)>0){					
					camposLista[1] = "sucursalID";
					parametrosLista[1] = sucursalID;
					camposLista[0] = "clienteID";
					lista('clienteID', '2', '16', camposLista, parametrosLista, 'listaCliente.htm');
				}else{
					camposLista[0] = "nombreCompleto";
					lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
				}
			}
			
		}
		
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});	

	$('#generar').click(function() {
		if($('#pdf').is(":checked") ){
			tipoReporte = catTipoReporte.pdf; 
		}else if($('#excel').is(":checked") ){
			tipoReporte = catTipoReporte.excel; 
		}
		generaReporte();
	});

	 /*REPORTE PDF*/
    function generaReporte(){ 
    	var fechaReporte = $('#fechaReporte').val();
		var tipoCedes 	 = $('#tipoCedeID').val();
		var nombreTipoCede = $('#descripcion').val();
		var promotor  	 = $('#promotorID').val();
		var nombrePromotor = $('#nombrePromotor').val();
		var sucursal  	 = $('#sucursalID').val();
		var nombreSucursal = $('#nombreSucursal').val();
		var cliente	  	 = $('#clienteID').val();
		var nombreCliente = $('#nombreCliente').val();
		var usuario 	 = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var safilocaleCliente = $('#socioCliente').val();
		
		var liga = 'cedesPorAutorizarReporte.htm?'+
				'fechaReporte='+fechaReporte+
				'&tipoCedeID='+tipoCedes+
				'&descripcion='+nombreTipoCede+
				'&promotorID='+promotor+
				'&nombrePromotor='+nombrePromotor+
				'&sucursalID='+sucursal+
				'&nombreSucursal='+nombreSucursal+
				'&clienteID='+cliente+
				'&nombreCliente='+nombreCliente+
				'&nombreUsuario='+usuario.toUpperCase()+
				'&tipoRep='+tipoReporte+
				'&safilocaleCliente='+safilocaleCliente+
				'&nombreInstitucion='+nombreInstitucion;
		window.open(liga, '_blank');
    }

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).asNumber();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente > 0 && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente.toString(),function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero)	;						
					$('#nombreCliente').val(cliente.nombreCompleto);																								
				}else{
					mensajeSis("No Existe el " + $('#socioCliente').val() + ".");
					$('#clienteID').val('0')	;	
					$('#nombreCliente').val('TODOS');
					$('#clienteID').focus();
				}    	 						
			});
		} else {
			$('#clienteID').val('0')	;	
			$('#nombreCliente').val('TODOS');
		}
	}
	
	function iniciaPantalla(){
		$('#fechaReporte').val(parametroBean.fechaSucursal);
		$('#clienteID').val('0');
		$('#nombreCliente').val('TODOS');
		$('#promotorID').val('0');
		$('#nombrePromotor').val('TODOS');
	    $('#sucursalID').val('0');
	    $('#nombreSucursal').val('TODAS');
		$('#tipoCedeID').val('0');
		$('#descripcion').val('TODOS');
	}
	
	function consultaPromotor(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).asNumber();	
		var tipConForanea = 2;	
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor > 0 && esTab){
			promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
				if(promotor!=null){							
					$('#nombrePromotor').val(promotor.nombrePromotor); 
					$('#sucursalID').val(promotor.sucursalID);
					consultaSucursal('sucursalID');
					deshabilitaControl('sucursalID');
					$('#clienteID').focus();
				}else{
					mensajeSis("No Existe el Promotor");
					$(jqPromotor).val(0);
					$('#nombrePromotor').val('TODOS');
					$('#promotorID').focus();
					$('#sucursalID').val(0);
					$('#nombreSucursal').val('TODAS');
					habilitaControl('sucursalID');
					$('#sucursalID').focus();
				}    	 						
			});
		} else if($(jqPromotor).val()!=''){
			$(jqPromotor).val(0);
			$('#nombrePromotor').val('TODOS');			
			$('#sucursalID').val(0);
			$('#nombreSucursal').val('TODAS');
			habilitaControl('sucursalID');
			$('#sucursalID').focus();
		}
	}

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var tipoSucursal = $(jqSucursal).val();

		setTimeout("$('#cajaLista').hide();", 200);
		if (tipoSucursal != '' && !isNaN(tipoSucursal)) {
          if(tipoSucursal==0){
            $('#sucursalID').val(0);
	        $('#nombreSucursal').val('TODAS');
          }
         else{
			sucursalesServicio.consultaSucursal(catTipoConsultaCedes.principalSucursal, tipoSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursal').val(sucursal.nombreSucurs);
										
				} else {
					mensajeSis("No Existe la Sucursal.");
					$('#nombreSucursal').val('');
					$('#sucursalID').focus();
					$('#sucursalID').select();
				}
			});
		  }
		}
	}
	
	function consultaTipoCede(tipCede){
		var TipoCedeBean ={
			'tipoCedeID' :tipCede
		};
		var tipoCedeID = Number(tipCede);
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoCedeID > 0 && esTab){
			if(tipCede != 0){
				tiposCedesServicio.consulta(catTipoConsultaTipoCede.general,TipoCedeBean, { async: false, callback: function(tipoCede){
					if(tipoCede!=null){	
						$('#tipoCedeID').val(tipoCede.tipoCedeID);
						$('#descripcion').val(tipoCede.descripcion);
					}else{
						mensajeSis("El tipo de CEDE no Existe.");
						$('#tipoCedeID').focus();
						$('#tipoCedeID').val('');
						$('#descripcion').val('');
					}
				}});
			}
		} else if(tipoCedeID == 0 && esTab){
			$('#tipoCedeID').val('0');
			$('#descripcion').val('TODOS');
		}
	}
	
});