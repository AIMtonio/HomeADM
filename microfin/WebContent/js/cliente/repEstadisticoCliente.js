
$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();  
	//Definicion de Constantes y Enums  
	var catTipoTransaccionConocimientoCte = {
			'agrega':'1',
			'modifica':'2'	};

	var catTipoConsultaConocimientoCte = {
			'principal'	:	1,
			'foranea'	:	2
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica'); 
  	consultaSucursal();

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
		
		  generaReporteRequisicion(); 
	});

	function generaReporteRequisicion(){
		var tipoReporte = 0;
		var tipoLista = 0;
		
		var sucursal = $("#sucursalID option:selected").val();
 		var usuario = 	parametroBean.nombreUsuario;
		var promotorID = $('#promotorID').val();
		var genero =$("#sexo option:selected").val();
		var estadoID=$('#estadoID').val();
		var municipioID=$('#municipioID').val();
		var fechaEmision = parametroBean.fechaSucursal;

		/// VALORES TEXTO
		var nombreSucursal = $("#sucursalID option:selected").val();
 		var nombreUsuario = parametroBean.nombreUsuario; 
		var nombrePromotor = $('#nombrePromotorI').val();
		var nombreGenero =$("#sexo option:selected").val();
		var nombreEstado=$('#nombreEstado').val();
		var nombreMunicipio=$('#nombreMuni').val();	
		var nombreInstitucion =  parametroBean.nombreInstitucion; 

		if(nombreSucursal=='0'){
			nombreSucursal='';
		}
		else{
			nombreSucursal = $("#sucursalID option:selected").html();
		}

	  

		 

		if(nombreGenero=='0'){
			nombreGenero='';
		}else{
			nombreGenero =$("#sexo option:selected").html();
		}
		if(genero=='0'){
			genero='';
		}
		
		if($('#pantalla').is(':checked')){
			tipoReporte = 1;

		}
		if($('#pdf').is(':checked')){
			tipoReporte = 2;
		}
		
		/// VALORES TEXTO
	 	 
		

		$('#ligaGenerar').attr('href','repEstadisticosCliente.htm?'
				  +'sucursalID='+sucursal
				  +'&promotorID='+promotorID
				  +'&genero='+genero
				  +'&estadoID='+estadoID
				  +'&municipioID='+municipioID
				  +'&nombrePromotor='+nombrePromotor
				  +'&nombreGenero='+nombreGenero
				  +'&nombreEstado='+nombreEstado
				  +'&nombreMunicipio='+nombreMunicipio
				  +'&nombreInstitucion='+nombreInstitucion
				  +'&fechaSistema='+fechaEmision
				  +'&nombreSucursal='+nombreSucursal
				  +'&nombreUsuario='+usuario
				  +'&tipoReporte='+tipoReporte
				  +'&tipoLista='+tipoLista);


	}





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
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Todas'});
		sucursalesServicio.listaCombo(tipoCon, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}


 

});
