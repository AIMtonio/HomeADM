$(document).ready(function() {
	
	$('#GrupoEmpID').focus();
	
		
	esTab=true;
		
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGruposEmp = {
  		'agrega':'1',
  		'modifica':'2'
	};

	var catTipoListaGrupoEmp = {
  		'principal':1
	};	


	var catTipoConsultaGrupoEmp = {
  		'principal':1
	};	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	deshabilitaBoton('agrega', 'submit');		
	deshabilitaBoton('modifica', 'submit');

	 
	$(':text').focus(function() {	
	 	esTab = false;
	});

		$.validator.setDefaults({
            submitHandler: function(event) { 
                    //grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','GrupoEmpID'); 
       			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','GrupoEmpID','exitoTrans','');

            }
    });

				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionGruposEmp.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionGruposEmp.modifica);
		
	});	
	
	
	$('#GrupoEmpID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('GrupoEmpID', '3', '1', 'nombreGrupo',
				$('#GrupoEmpID').val(), 'listaEmpresas.htm');
	});	
	
		
	$('#GrupoEmpID').blur(function() {
		validaGrupoEmpresarial(this);
	});		
			
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			GrupoEmpID: {
				required: false
			},
			NombreGrupo: 'required',
			Observacion: 'required'
		},
		messages: {
			NombreGrupo: {
				required: 'Especificar nombre',
				minlength: 'Al menos dos Caracteres'

			},
			Observacion: {
				required: 'Indicar observacion'
			}
		
		}		
	});
	//------------ Validaciones de Controles -------------------------------------

	function validaGrupoEmpresarial(control){
		var numEmpresa = $('#GrupoEmpID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numEmpresa != '' && !isNaN(numEmpresa) && esTab){
			
			if(numEmpresa=='0'){
				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','GrupoEmpID' )
				
			} else {	
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');	
				var conTipoCon = catTipoConsultaGrupoEmp.principal;		
				gruposEmpServicio.consulta(conTipoCon, numEmpresa,function(empresa) {
						if(empresa!=null){
						dwr.util.setValues(empresa);	
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');													
						}else{
							limpiaForm($('#formaGenerica'));
							mensajeSis("No Existe el Cliente");
							deshabilitaBoton('modifica', 'submit');
   							deshabilitaBoton('agrega', 'submit');
								$('#GrupoEmpID').focus();
								$('#GrupoEmpID').select();	
																			
							}
				});
								
			}
												
		}
	}			
			
		
});

function exitoTrans(){
	inicializaForma('formaGenerica','GrupoEmpID');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
}