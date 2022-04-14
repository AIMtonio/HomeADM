$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTipoFonde = {   
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaInstFonde = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    $('#institutFondID').focus();	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$.validator.setDefaults({
            submitHandler: function(event) { 

            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoLinFondeaID','exito','error'); 
            }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTipoFonde.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionTipoFonde.modifica);
	});	
	//··········°° arroja la lista de las instituciones 
	$('#institutFondID').bind('keyup',function(e){
		lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
	});

	$('#institutFondID').blur(function() { 
		$('#descripcion').val('');	
		$('#tipoLinFondeaID').val('');	
		deshabilitaBoton('modifica', 'submit');
  		validaInstitucion(this.id); 
  		if ($('#institutFondID').val()==''){
  			$('#nombreInstitFon').val('');
  		}
	});
 
	
	
	 $('#tipoLinFondeaID').bind('keyup',function(e){
		    var vacio='';
	    	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tipoLinFondeaID";
			camposLista[1] = "institutFondID";
			parametrosLista[0] = $('#tipoLinFondeaID ').val();
			parametrosLista[1] = $('#institutFondID').val();
			
			if($('#institutFondID').val()!= vacio){
			lista('tipoLinFondeaID', '1', '2', camposLista, parametrosLista,'listaTipoLineaFondea.htm');
			}else{
			lista('tipoLinFondeaID', '1', '1', 'descripcion', $('#tipoLinFondeaID').val(), 'listaTipoLineaFondea.htm');
			}
	 });
	
	$('#tipoLinFondeaID').blur(function() {
		consultaTipoLinFondea(this.id); 
		if ($('#tipoLinFondeaID').val()==''){
  			$('#descripcion').val('');
  			deshabilitaBoton('modifica', 'submit');
  			deshabilitaBoton('agrega', 'submit');
  		}
		if($('#tipoLinFondeaID').val()!=0 && $('#descripcion').val()=='')
			{

  			deshabilitaBoton('modifica', 'submit');
			}
		

	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			tipoLinFondeaID: {
				required:function() { return $('#descripcion').val()!='';},	
			},
			descripcion:{
				required:function() { return $('#tipoLinFondeaID').val()!='';},	

			},
			institutFondID:{
				required:true
			}
			
		},
		messages: {
			tipoLinFondeaID: {
				 required:'Especifique Tipo de Linea de Fondeo.' ,
	
			 },
			 descripcion:{
				 required:'Especifique La Descripción del Tipo de Linea de Fondeo.' ,
			 },
			
			 institutFondID:{
				 required:'Especifique La Institución de Fondeo.' 
		
			 }
		}		
	});
	

	//------------ Validaciones de Controles -------------------------------------
		function validaInstitucion(control) {
			var numInst = $('#institutFondID').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if(numInst != '' && !isNaN(numInst) && esTab){
				var instFondeoBeanCon = {
						'institutFondID':$('#institutFondID').val()  		
				};
				fondeoServicio.consulta(catTipoConsultaInstFonde.principal,instFondeoBeanCon,function(instFondeo) {
						if(instFondeo!=null){
							//dwr.util.setValues(instFondeo);	
							esTab=true;			
							$('#nombreInstitFon').val(instFondeo.nombreInstitFon);
							$('#institutFondID').val(instFondeo.institutFondID);	
											
						}else{
							mensajeSis("No Existe la Institucion de Fondeo");
								$('#institutFondID').focus();
								$('#institutFondID').select();
								$('#institutFondID').val('');
								$('#nombreInstitFon').val('');
							
					
							}
			    });
						
			}
		}

		// funcion que Consulta los tipos de linea de fondeo
		function consultaTipoLinFondea(idControl) {
			var jqTipoLinea = eval("'#" + idControl + "'");
			var numTipoLinea = $(jqTipoLinea).val();	
			var numInstit =$('#institutFondID').val();
			var vacio='';
			var tipoLFondeoBeanCon = {  
					'tipoLinFondeaID':numTipoLinea,
			};
			if(numTipoLinea =='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
     			$('#descripcion').val('');	
			}else{

				setTimeout("$('#cajaLista').hide();", 200);		 
				if(numTipoLinea != '' && !isNaN(numTipoLinea) && esTab){
					if($('#institutFondID').val()!=vacio){
					tiposLineaFonServicio.consultaTiposInstitut(3,numTipoLinea,numInstit, function(tipoLinea) {
						if(tipoLinea!=null){
							$('#descripcion').val(tipoLinea.descripcion);
							habilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');

						}else{
							
							mensajeSis("No Existe el Tipo de Linea de Fondeo"); 
							$('#tipoLinFondeaID').focus();
							$('#tipoLinFondeaID').select();
							$('#tipoLinFondeaID').val('');	
							$('#descripcion').val('');	
							}    						
					});
					}else{
						tiposLineaFonServicio.consulta(2,tipoLFondeoBeanCon, function(tipoLinea) {
							if(tipoLinea!=null){
								$('#descripcion').val(tipoLinea.descripcion);
								$('#institutFondID').val(tipoLinea.institutFondID);	
								validaInstitucion('institutFondID');

							}else{
								mensajeSis("No Existe el Tipo de Linea de Fondeo"); 
								$('#tipoLinFondeaID').focus();
								$('#tipoLinFondeaID').select();
								$('#tipoLinFondeaID').val('');	
								$('#descripcion').val('');	
								
								}    
						});
					}
				}
			}
		}
	

		
});// fin jquery
function exito(){
	$('#tipoLinFondeaID').focus();
//	$('#tipoLinFondeaID').select();
	$('#descripcion').val('');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');	
	esTab=false;
}
function error(){
	$('#tipoLinFondeaID').focus();
	$('#tipoLinFondeaID').select();
	deshabilitaBoton('agrega', 'submit');	
	deshabilitaBoton('modifica', 'submit');
}
var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}