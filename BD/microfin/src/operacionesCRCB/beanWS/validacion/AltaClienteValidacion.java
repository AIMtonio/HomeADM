package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaClienteRequest;
import operacionesCRCB.beanWS.response.AltaClienteResponse;

public class AltaClienteValidacion {

	private AltaClienteRequest altaClienteRequest= null;
	private AltaClienteResponse altaClienteResponse = null;
		

	public boolean isPrimerNombreValid(){
	altaClienteRequest.setPrimerNombre(altaClienteRequest.getPrimerNombre().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getPrimerNombre().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("3");
	      altaClienteResponse.setMensajeRespuesta("El Primer Nombre está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isApellidoPaternoValid(){
	altaClienteRequest.setApellidoPaterno(altaClienteRequest.getApellidoPaterno().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getApellidoPaterno().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("4");
	      altaClienteResponse.setMensajeRespuesta("El Apellido Paterno está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isSexoValid(){
	altaClienteRequest.setSexo(altaClienteRequest.getSexo().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getSexo().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("9");
	      altaClienteResponse.setMensajeRespuesta("El Sexo está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isPuestoValid(){
	altaClienteRequest.setPuesto(altaClienteRequest.getPuesto().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getPuesto().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("10");
	      altaClienteResponse.setMensajeRespuesta("El Puesto está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isAntiguedadTraValid(){
	altaClienteRequest.setAntiguedadTra(altaClienteRequest.getAntiguedadTra().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getAntiguedadTra().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("11");
	      altaClienteResponse.setMensajeRespuesta("La Antiguedad de Trabajo está Vacía.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getAntiguedadTra()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Antiguedad de Trabajo es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	
	public boolean isEstadoIDValid(){
	altaClienteRequest.setEstadoID(altaClienteRequest.getEstadoID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getEstadoID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("8");
	      altaClienteResponse.setMensajeRespuesta("El Estado está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getEstadoID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Estado es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isMunicipioIDValid(){
	altaClienteRequest.setMunicipioID(altaClienteRequest.getMunicipioID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getMunicipioID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("14");
	      altaClienteResponse.setMensajeRespuesta("El Municipio está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getMunicipioID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Municipio es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isLocalidadIDValid(){
	altaClienteRequest.setLocalidadID(altaClienteRequest.getLocalidadID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getLocalidadID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("19");
	      altaClienteResponse.setMensajeRespuesta("La Localidad está Vacía.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getLocalidadID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Localidad es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isColoniaIDValid(){
	altaClienteRequest.setColoniaID(altaClienteRequest.getColoniaID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getColoniaID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("17");
	      altaClienteResponse.setMensajeRespuesta("La Colonia está Vacía.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getColoniaID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Colonia es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isCalleValid(){
	altaClienteRequest.setCalle(altaClienteRequest.getCalle().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getCalle().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("15");
	      altaClienteResponse.setMensajeRespuesta("La Calle está Vacía.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isNumeroValid(){
	altaClienteRequest.setNumero(altaClienteRequest.getNumero().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getNumero().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("16");
	      altaClienteResponse.setMensajeRespuesta("El Número está Vacío.");
	      return false;
	  }
	  return true;
	}
		
	
	public boolean isFechaNacimientoValid(){
	altaClienteRequest.setFechaNacimiento(altaClienteRequest.getFechaNacimiento().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getFechaNacimiento().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("30");
	      altaClienteResponse.setMensajeRespuesta("La Fecha de Nacimiento está Vacía.");
	      return false;
	  }
	  if (! Utileria.esFecha(altaClienteRequest.getFechaNacimiento()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Fecha de Nacimiento es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isCURPValid(){
	altaClienteRequest.setCURP(altaClienteRequest.getCURP().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getCURP().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("31");
	      altaClienteResponse.setMensajeRespuesta("La CURP está Vacía.");
	      return false;
	  }
	  return true;
	}
		
	public boolean isEstadoNacimientoIDValid(){
	altaClienteRequest.setEstadoNacimientoID(altaClienteRequest.getEstadoNacimientoID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getEstadoNacimientoID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("32");
	      altaClienteResponse.setMensajeRespuesta("El Estado de Nacimiento está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getEstadoNacimientoID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Estado de Nacimiento es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isTelefonoCelularValid(){
	altaClienteRequest.setTelefonoCelular(altaClienteRequest.getTelefonoCelular().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getTelefonoCelular().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("33");
	      altaClienteResponse.setMensajeRespuesta("El Teléfono Celular está Vacío.");
	      return false;
	  }
	  return true;
	}
		
		
	public boolean isRFCValid(){
	altaClienteRequest.setRFC(altaClienteRequest.getRFC().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getRFC().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("34");
	      altaClienteResponse.setMensajeRespuesta("El RFC está Vacío.");
	      return false;
	  }
	  return true;
	}
		
	public boolean isOcupacionIDValid(){
	altaClienteRequest.setOcupacionID(altaClienteRequest.getOcupacionID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getOcupacionID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("35");
	      altaClienteResponse.setMensajeRespuesta("La Ocupación está Vacía.");
	      return false;
	  }
	  return true;
	}
		
	public boolean isLugardeTrabajoValid(){
	altaClienteRequest.setLugardeTrabajo(altaClienteRequest.getLugardeTrabajo().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getLugardeTrabajo().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("36");
	      altaClienteResponse.setMensajeRespuesta("El Lugar de Trabajo está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isSucursalOrigenValid(){
	altaClienteRequest.setSucursalOrigen(altaClienteRequest.getSucursalOrigen().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getSucursalOrigen().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("37");
	      altaClienteResponse.setMensajeRespuesta("La Sucursal de Origen está Vacía.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getSucursalOrigen()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Sucursal de Origen es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isTipoPersonaValid(){
	altaClienteRequest.setTipoPersona(altaClienteRequest.getTipoPersona().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getTipoPersona().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("38");
	      altaClienteResponse.setMensajeRespuesta("El Tipo de Persona está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isPaisNacionalidadValid(){
		altaClienteRequest.setPaisNacionalidad(altaClienteRequest.getPaisNacionalidad().replace("?", Constantes.STRING_VACIO));
		if(altaClienteRequest.getPaisNacionalidad().equals(Constantes.STRING_VACIO)){
			altaClienteResponse.setCodigoRespuesta("39");
		    altaClienteResponse.setMensajeRespuesta("El País de nacionalidad está Vacío.");
			return false;
		}
		if (! Utileria.esNumero(altaClienteRequest.getPaisNacionalidad()) ){
			  altaClienteResponse.setCodigoRespuesta("400"); 
			  altaClienteResponse.setMensajeRespuesta("El Formato País de Nacionalidad es Inválido."); 
			  return false; 
		  }
		return true;
	}
	
	public boolean isIngresosMensualesValid(){
		altaClienteRequest.setIngresosMensuales(altaClienteRequest.getIngresosMensuales().replace("?", Constantes.STRING_VACIO));
		if(altaClienteRequest.getIngresosMensuales().equals(Constantes.STRING_VACIO)){
			altaClienteResponse.setCodigoRespuesta("40");
		    altaClienteResponse.setMensajeRespuesta("El Ingreso Mensual está Vacío.");
			return false;
		}
		if (! Utileria.esDouble(altaClienteRequest.getIngresosMensuales()) ){
			  altaClienteResponse.setCodigoRespuesta("400"); 
			  altaClienteResponse.setMensajeRespuesta("El Formato Ingresos Mensuales es Inválido."); 
			  return false; 
		  }
		return true;
	}
	
	public boolean isTamanioAcreditadoValid(){
		altaClienteRequest.setTamanioAcreditado(altaClienteRequest.getTamanioAcreditado().replace("?", Constantes.STRING_VACIO));
		if(altaClienteRequest.getTamanioAcreditado().equals(Constantes.STRING_VACIO)){
			altaClienteResponse.setCodigoRespuesta("27");
		    altaClienteResponse.setMensajeRespuesta("La clave Tamaño del Acreditado es incorrecto.");
			return false;
		}
		if (! Utileria.esNumero(altaClienteRequest.getTamanioAcreditado()) ){
			  altaClienteResponse.setCodigoRespuesta("400"); 
			  altaClienteResponse.setMensajeRespuesta("El Formato Tamaño del Acreditado es Inválido."); 
			  return false; 
		  }
		return true;
	}
	
	public boolean isNiveldeRiesgoValid(){
		altaClienteRequest.setNiveldeRiesgo(altaClienteRequest.getNiveldeRiesgo().replace("?", Constantes.STRING_VACIO));
		if(altaClienteRequest.getNiveldeRiesgo().equals(Constantes.STRING_VACIO)){
			altaClienteResponse.setCodigoRespuesta("28");
		    altaClienteResponse.setMensajeRespuesta("El Nivel de Riesgo es incorrecto.");
			return false;
		}
		return true;
	}
	
	public boolean isTituloValid(){
	altaClienteRequest.setTitulo(altaClienteRequest.getTitulo().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getTitulo().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("43");
	      altaClienteResponse.setMensajeRespuesta("El Título está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isPaisResidenciaValid(){
	altaClienteRequest.setPaisResidencia(altaClienteRequest.getPaisResidencia().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getPaisResidencia().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("44");
	      altaClienteResponse.setMensajeRespuesta("El País de Residencia está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getPaisResidencia()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato País de Residencia es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isSectorGeneralValid(){
	altaClienteRequest.setSectorGeneral(altaClienteRequest.getSectorGeneral().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getSectorGeneral().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("45");
	      altaClienteResponse.setMensajeRespuesta("El Sector General está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getSectorGeneral()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Sector General es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isActividadBancoMXValid(){
	altaClienteRequest.setActividadBancoMX(altaClienteRequest.getActividadBancoMX().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getActividadBancoMX().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("46");
	      altaClienteResponse.setMensajeRespuesta("La Actividad está Vacía.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isEstadoCivilValid(){
	altaClienteRequest.setEstadoCivil(altaClienteRequest.getEstadoCivil().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getEstadoCivil().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("47");
	      altaClienteResponse.setMensajeRespuesta("El Estado Civil está Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isLugarNacimientoValid(){
	altaClienteRequest.setLugarNacimiento(altaClienteRequest.getLugarNacimiento().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getLugarNacimiento().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("48");
	      altaClienteResponse.setMensajeRespuesta("El Lugar de Nacimiento está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getLugarNacimiento()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Lugar de Nacimiento es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isPromotorInicialValid(){
	altaClienteRequest.setPromotorInicial(altaClienteRequest.getPromotorInicial().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getPromotorInicial().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("49");
	      altaClienteResponse.setMensajeRespuesta("El Promotor Inicial está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getPromotorInicial()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Promotor Inicial es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isPromotorActualValid(){
	altaClienteRequest.setPromotorActual(altaClienteRequest.getPromotorActual().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getPromotorActual().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("50");
	      altaClienteResponse.setMensajeRespuesta("El Promotor Actual está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getPromotorActual()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Promotor Actual es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isTipoDireccionIDValid(){
	altaClienteRequest.setTipoDireccionID(altaClienteRequest.getTipoDireccionID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getTipoDireccionID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("51");
	      altaClienteResponse.setMensajeRespuesta("El Tipo de Dirección está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getTipoDireccionID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Tipo de Dirección es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isOficialValid(){
	altaClienteRequest.setOficial(altaClienteRequest.getOficial().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getOficial().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("52");
	      altaClienteResponse.setMensajeRespuesta("Indique si es Dirección Oficial.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isFiscalValid(){
	altaClienteRequest.setFiscal(altaClienteRequest.getFiscal().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getFiscal().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("53");
	      altaClienteResponse.setMensajeRespuesta("Indique si es Dirección Fiscal.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isTipoIdentiIDValid(){
	altaClienteRequest.setTipoIdentiID(altaClienteRequest.getTipoIdentiID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getTipoIdentiID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("54");
	      altaClienteResponse.setMensajeRespuesta("Indique el Tipo de Identificación.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getTipoIdentiID()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Tipo de Identificación es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isNumIdentificValid(){
	altaClienteRequest.setNumIdentific(altaClienteRequest.getNumIdentific().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getNumIdentific().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("55");
	      altaClienteResponse.setMensajeRespuesta("Indique el Número del Documento de Identificación.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isUsuarioValid(){
	altaClienteRequest.setUsuario(altaClienteRequest.getUsuario().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("901");
	      altaClienteResponse.setMensajeRespuesta("Campo Usuario Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getUsuario()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Usuario de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isDireccionIPValid(){
	altaClienteRequest.setDireccionIP(altaClienteRequest.getDireccionIP().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("902");
	      altaClienteResponse.setMensajeRespuesta("Campo DireccionIP Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isProgramaIDValid(){
	altaClienteRequest.setProgramaID(altaClienteRequest.getProgramaID().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("903");
	      altaClienteResponse.setMensajeRespuesta("Campo ProgramaID Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isSucursalValid(){
	altaClienteRequest.setSucursal(altaClienteRequest.getSucursal().replace("?", Constantes.STRING_VACIO));
	  if ( altaClienteRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
	      altaClienteResponse.setCodigoRespuesta("904");
	      altaClienteResponse.setMensajeRespuesta("Campo Sucursal Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaClienteRequest.getSucursal()) ){
		  altaClienteResponse.setCodigoRespuesta("400"); 
		  altaClienteResponse.setMensajeRespuesta("El Formato Sucursal de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public AltaClienteResponse isRequestValid(AltaClienteRequest altaClienteRequest){
		this.altaClienteRequest = altaClienteRequest;
		altaClienteResponse = new AltaClienteResponse();

		altaClienteRequest.setClienteId(altaClienteRequest.getClienteId().replace("?", "0"));
		altaClienteResponse.setClienteID(altaClienteRequest.getClienteId());
		
		if(altaClienteRequest.getClienteId() == "0"){
		
			if(
				isPrimerNombreValid() &
				isApellidoPaternoValid() &
				isFechaNacimientoValid() &
				isCURPValid() &
				isEstadoNacimientoIDValid() &
				isSexoValid() &
				isTelefonoCelularValid() &
				isRFCValid() &
				isOcupacionIDValid() &
				isLugardeTrabajoValid() &
				isPuestoValid() &
				isAntiguedadTraValid() &
				isSucursalOrigenValid() &
				isTipoPersonaValid() &
				isPaisNacionalidadValid() &
				isIngresosMensualesValid() &
				isTamanioAcreditadoValid() &
				isNiveldeRiesgoValid() &
				isTituloValid() &
				isPaisResidenciaValid() &
				isSectorGeneralValid() &
				isActividadBancoMXValid() &
				isEstadoCivilValid() &
				isLugarNacimientoValid() &
				isPromotorInicialValid() &
				isPromotorActualValid() &
				isTipoDireccionIDValid() &
				isEstadoIDValid() &
				isMunicipioIDValid() &
				isLocalidadIDValid() &
				isColoniaIDValid() &
				isCalleValid() &
				isNumeroValid() &
				isOficialValid() &
				isFiscalValid() &
				isTipoIdentiIDValid() &
				isNumIdentificValid() &
				isUsuarioValid() &
				isDireccionIPValid() &
				isProgramaIDValid() &
				isSucursalValid() 
			){
				altaClienteResponse.setCodigoRespuesta("0");
				altaClienteResponse.setMensajeRespuesta("Request válido");
			}
		}else {
			altaClienteResponse.setCodigoRespuesta("0");
			altaClienteResponse.setMensajeRespuesta("Request válido");
		}	
		return altaClienteResponse;
	}
	
	
	public AltaClienteRequest getAltaClienteRequest() {
		return altaClienteRequest;
	}

	public void setAltaClienteRequest(AltaClienteRequest altaClienteRequest) {
		this.altaClienteRequest = altaClienteRequest;
	}
	
	
	
	
}
