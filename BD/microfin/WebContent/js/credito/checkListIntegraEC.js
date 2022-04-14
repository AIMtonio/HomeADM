$(document).ready(function (){
	esTab = true;
	var parametros = consultaParametrosSession();
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

	
	$('#nuCliente').bind('keyup',function(e){
		lista('nuCliente', '3', '1', 'nombreCompleto', $('#nuCliente').val(), 'listaCliente.htm');
	});
	$('#nuCliente').blur(function(){
		if(Number($('#nuCliente').val()) <= 0 || isNaN($('#nuCliente').val()) ){
			$('#nuCliente').val('0');
			$('#noCliente').val('');
		}else{
			$('#nuGrupo').val('0');
			$('#noGrupo').val('');
			var tipoconsultaforanea=2;
			clienteServicio.consulta(tipoconsultaforanea,$('#nuCliente').val(), "", function (nombrecliente){
				if(nombrecliente != null){
					$('#noCliente').val(nombrecliente.nombreCompleto);
				}else{
					$('#nuCliente').val('0');
					$('#noCliente').val('');
					mensajeSis('Incorrecto Número de cliente');}
			});
			
		}
	});
	
	$('#nuGrupo').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
				var camposLista = new Array(); 
			    var parametrosLista = new Array(); 
			    	camposLista[0] = "nombreGrupo";
			    	parametrosLista[0] = $('#nuGrupo').val();
		listaAlfanumerica('nuGrupo', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
		
	});
	$('#nuGrupo').blur(function(){
		if(Number($('#nuGrupo').val()) <= 0 || isNaN($('#nuGrupo').val()) ){
			$('#nuGrupo').val('0');
			$('#noGrupo').val('');
		}else{
			$('#nuCliente').val('0');
			$('#noCliente').val('');
			var tipoconsultapricipal = 1;
			var bean = {
					'grupoID':$('#nuGrupo').val()
			};
//			tablaLista
			gruposCreditoServicio.consulta(tipoconsultapricipal,bean, function(grupo){
				if(grupo != null){
					$('#noGrupo').val(grupo.nombreGrupo);
				}else{
					$('#nuGrupo').val('0');
					$('#noGrupo').val('');
					mensajeSis('Incorrecto Número de Grupo');
				}
			});
			
			
		}
		
	});
	
	$('#generar').click(function() {
		
		
		if($('#nuGrupo').val()== '0' && $('#nuCliente').val() == '0' ){
			mensajeSis('Coloque un número de grupo o de cliente valido');
			return false;
		}
			var tipoReporte	= 1;
			var nombreInst		= parametros.nombreInstitucion;	
			var nombreGrupo		= $('#noGrupo').val();
			var nomCliente 		= $('#noCliente').val();
			var numeroCliente 	= $('#nuCliente').val();
			var numeroGrupo		= $('#nuGrupo').val();
			
			var ClienteConCaracter = nomCliente;
			nomCliente = ClienteConCaracter.replace(/\&/g, "%26");

			$('#ligaPDF').attr('href',
					'pdfCheckListIntegraEC.htm?nombreInstitucion='+nombreInst+
					'&nombreGrupo='+nombreGrupo+
					'&nombreCliente='+nomCliente+
					'&numeroCliente='+numeroCliente+
					'&numeroGrupo='+numeroGrupo+
					"&tipoReporte="+tipoReporte);	
//			http://localhost:8080/microfin/pdfCheckListIntegraEC.htm?nombreInst=juanitoperezintit&nombreGrupo=locosteam&nomCliente=forevercrazy&numeroCliente=2&numeroGrupo=0&tipoReporte=1
	});


	
	$('#formaGenerica').validate({				
		rules: {
			nuCliente: {
				required: true
			},
			nuGrupo: {
				required: true
			}
			
		},		
		messages: {
			nuCliente: {
				required: 'Especifique Número de Cliente o Número de Grupo'
			},
			nuGrupo : {
				required: 'Especifique Número de Cliente o Número de Grupo'
			}
		}		
	});
	

 	
 	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'Selecciona'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
 	}
 	

	
});

