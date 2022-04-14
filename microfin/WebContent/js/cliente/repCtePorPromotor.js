
$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
  //	consultaSucursal();

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');	
	});
	
	$('#sucursalID').blur(function(){
		consultaSucursal(this.id);
		$('#promotorID').val('0');
		$('#nombrePromotor').val('TODOS');
	});
	
	$('#promotorID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorID').val();
		parametrosLista[1] = $('#sucursalID').val();
				
		if($('#sucursalID').val()=='0'){
		lista('promotorID', '2', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');

		}else if($('#sucursalID').asNumber()>0){
			lista('promotorID', '2', '4', camposLista,
					parametrosLista, 'listaPromotores.htm');
		}
		
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
		
		  generaReporte(); 
	});

	function generaReporte(){
		
		var sucursalID = $("#sucursalID").val();
 		var claveUsuario = 	parametroBean.claveUsuario;
		var promotorAct = $('#promotorID').val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var fechaActual = parametroBean.fechaSucursal;
		var nombreSucursal = $("#nombreSucursal").val();
		var nombrePromotor = $('#nombrePromotor').val();
		var sexo =$("#sexo option:selected").val();
		var nombreEstado=$('#nombreEstado').val();
		var nombreMunicipio=$('#nombreMunicipio').val();	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var estatus=		$("#estatus option:selected").val();
		var direccion=parametroBean.direccionInstitucion;

		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		if(nombrePromotor=='0'){
			nombrePromotor='';
		}
		if(nombreEstado=='0'){
			nombreEstado='';
		}
		if(nombreMunicipio=='0'){
			nombreMunicipio='';
		}
						
		if (estatus=='0'){
			estatus="";
		} 

		if(sexo=='0'){
			sexo='';
		}
		
		/// VALORES TEXTO
		$('#ligaGenerar').attr('href','repCtesPromotor.htm?'
				  +'sucursalID='+sucursalID
				  +'&promotorAct='+promotorAct
				  +'&sexo='+sexo
				  +'&estadoID='+estadoID
				  +'&municipioID='+municipioID
				  +'&nombrePromotor='+nombrePromotor
				  +'&nombreEstado='+nombreEstado
				  +'&nombreMunicipio='+nombreMunicipio
				  +'&nombreInstitucion='+nombreInstitucion
				  +'&fechaActual='+fechaActual
				  +'&nombSucursal='+nombreSucursal
				  +'&clave='+claveUsuario
				  +'&estatus='+estatus
				  +'&direccion='+direccion);
	}





	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $('#promotorID').val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotor').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){
						if ($('#sucursalID').val()!="0"){
							if($('#sucursalID').val()==promotor.sucursalID){
								$('#nombrePromotor').val(promotor.nombrePromotor);
							}else{
								alert("El Promotor No Pertenece a la Sucursal");
								$('#nombrePromotor').val("TODOS");
								$('#promotorID').val("0");
								$('#promotorID').focus();
							}
						}else{
							$('#nombrePromotor').val(promotor.nombrePromotor);
						}
						
					}else{
						alert("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('TODOS');
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
				$('#nombreMunicipio').val('TODOS');
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
			$('#nombreMunicipio').val('TODOS');
		}
		else	
			if(numMunicipio != '' && !isNaN(numMunicipio)){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
					if(municipio!=null){							
						$('#nombreMunicipio').val(municipio.nombre);

					}else{
						alert("No Existe el Municipio");
						$('#municipioID').val(0);
						$('#nombreMunicipio').val('TODOS');
					}    	 						
				});
			}
	}	

	// fin validacion Promotor, Estado, Municipio
//
//
//	function consultaSucursal(){
//		var tipoCon=2;
//		dwr.util.removeAllOptions('sucursalID');
//		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
//		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
//			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
//		});
//	}
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numSucursal==0){
			  $('#sucursalID').val("0");
			  $('#nombreSucursal').val("TODAS");
			  
		}else{
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
						if(sucursal!=null){							
							$('#nombreSucursal').val(sucursal.nombreSucurs);								
						}else{
							alert("No Existe la Sucursal");
							  $('#sucursalID').focus();
							  $('#sucursalID').val("0");
							  $('#nombreSucursal').val("TODAS");
						}    						
				});
			}
		}
	 }
});
