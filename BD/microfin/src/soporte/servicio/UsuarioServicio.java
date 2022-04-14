package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.List;

import operacionesPDA.beanWS.response.SP_SMSAP_Usuarios_DescargaResponse;

import org.apache.log4j.Logger;

import com.google.gson.Gson;

import seguridad.bean.SessionesUsuarioBean;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.dao.ParametrosSisDAO;
import soporte.dao.UsuarioDAO;


public class UsuarioServicio extends BaseServicio {

	//----- Constantes ----------------------------------------------------------------------------
	public static interface Enum_Usuario_Logeado {
		String SI = "S";
		String NO = "N";
	}
	
	
	//---------- Variables ------------------------------------------------------------------------
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	UsuarioDAO usuarioDAO = null;
	ParametrosSisDAO parametrosSisDAO = null;
	static SessionesUsuarioBean sessionesUsuarioBean;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Usuario {
		int principal = 1;
		int foranea = 2;
		int clave = 3;
		int bloqueadoDesbloq = 4;
		int cancela = 5;			// Consulta para la cancelacion o reactivacion de usuario
		int contrasenia = 6;
		int consultaWS = 7;
		int consultaUsuPorNom = 8;
		int limpia = 9;
		int smsapValidaUserWS	=10;
		int pdaValidaUserWS	=11;
		int usuarioGestor = 12;
		int consultaUsuPorNomExterna=13;
		int consultaUsuAsamGral = 14;
		int validadUserWS = 15;
		int consultaEStatusAna = 20;
		int consultasolicitudes = 19;
		int consultaCoordinador = 21;	//Consulta 21 para los usuarios con rol de coordinador


	
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Usuario {
		int principal = 1;
		int porSucursal = 3;
		int usuarioGestor = 4;
		int comboGestor = 6;
		int comboSupervisor= 7;
		int userFR_WS= 8;   // lista usuarios activos con rol Ejecutivo rural, para WS
		int usuarioGestProm = 9;   
		int usuarioSupervisor= 10;  
		int usuarioSesionActiva =12;
		int usuAsamGral = 14;//lista de usuarios para covenciones seccionales
		int usuActBloq = 15;//lista de usuarios usuarios Activos o Bloqueados
		int usuvirtualAnalista=16;
		int usuRolAnalista=17;
		int lisRolCoordinador = 18; 
		int lisRolAsesor = 19; // lista para los usuarios con rol de asesor.
		int lisConCorreo = 20; // Lista para los usuarios activos y con correo
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Usuario {
		int alta = 1;
		int modificacion = 2;
		int actualizacion = 3;

	}
	//---------- calculo de fechas de password ----------------------------------------------------------------	
	public static interface Enum_Cal_fechPass {
		int resta = 1;

	}

	//---------- Tipo de Actualizacion --------------------------------------------------------------
	public static interface Enum_Act_Usuario {
		int loginsFallidos = 1;
		int actualizaBloDes = 2;
		int actualizaCancel = 3;
		int resetPassword = 4;
		int act_statusSesionAct =5;
		int act_statusSesInact =6;
		int actualizaSesion = 7;
		int nuevoPassword	= 8;
		int reactivacionUsu	= 9;		// reactiva un usuario cancelado
		int actualizaEstatusAnalisis=10;
	}

	public static interface Enum_Con_UsuarioA{
		int usuarioActivo =11;
	}
	public UsuarioServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean altaUsuario(UsuarioBean usuario){
		MensajeTransaccionBean mensaje = null;
		//Encriptamos la Contraseña
		if(usuario.getPrefijo()!=null)
		{
			usuario.setContrasenia(SeguridadRecursosServicio.encriptaPass(usuario.getPrefijo()+usuario.getClave(), usuario.getContrasenia()));

		}
		else{
			usuario.setContrasenia(SeguridadRecursosServicio.encriptaPass(usuario.getClave(), usuario.getContrasenia()));

		}

		mensaje = usuarioDAO.altaUsuario(usuario);
		//Registramos el Usuario en la BD Principal o Master, para el manejo de MultiCompañia
		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
			usuarioDAO.altaUsuarioBDPrincipal(usuario);	
		}
		
		return mensaje;
	}

	public MensajeTransaccionBean modificaUsuario(UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioDAO.modificaUsuario(usuario);
		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
			usuarioDAO.modificaUsuarioBDPrincipal(usuario);	
		}
		return mensaje;
	}

	public UsuarioBean consulta(int tipoConsulta, UsuarioBean usuarioBean){
		UsuarioBean usuario = null;
		switch (tipoConsulta) { 
		case Enum_Con_Usuario.principal:		
			usuario = usuarioDAO.consultaPrincipal(usuarioBean,tipoConsulta);				
			break;				
		case Enum_Con_Usuario.foranea:
			usuario = usuarioDAO.consultaForanea(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.clave:	
			usuario = usuarioDAO.consultaPorClaveBDPrincipal(usuarioBean, tipoConsulta);			
			if(usuario!=null){
				
				usuarioBean.setOrigenDatos(usuario.getOrigenDatos());
				usuarioBean.setRazonSocial(usuario.getRazonSocial());
				System.out.println("RazonSocial="+usuarioBean.getRazonSocial());
				usuario	= usuarioDAO.consultaPorClave(usuarioBean, tipoConsulta);
			}

			break;
		case Enum_Con_Usuario.bloqueadoDesbloq:				
			usuario = usuarioDAO.consultaBloDesbloqueo(usuarioBean, tipoConsulta);
			break;	
		case Enum_Con_Usuario.cancela:	// Consulta para la cancelacion o reactivacion de usuario			
			usuario = usuarioDAO.consultaCancelaUsuario(usuarioBean, tipoConsulta);
			break;	
		case Enum_Con_Usuario.contrasenia:				
			usuario = usuarioDAO.consultaContraseniaUsuario(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.consultaWS:	
			usuario = usuarioDAO.consultaWS(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.limpia:	
			usuario = usuarioDAO.consultaLimpiaSesion(usuarioBean, tipoConsulta);
			break;	
		case Enum_Con_Usuario.smsapValidaUserWS:	
			usuario = usuarioDAO.smsapValidaUserWS(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.pdaValidaUserWS:	
			usuario = usuarioDAO.pdaValidaUserWS(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.usuarioGestor:	
			usuario = usuarioDAO.consultaUsuarioGestor(usuarioBean, tipoConsulta);
			break;
			
		
		case Enum_Con_Usuario.consultaUsuPorNomExterna:	
			usuario = usuarioDAO.consultaUsuarioSupervisor(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.consultaUsuAsamGral:	
			usuario = usuarioDAO.consultaUsuAsamGral(usuarioBean, tipoConsulta);
			break;
			
		case Enum_Con_Usuario.validadUserWS:				
			usuario = usuarioDAO.pdaValidaUserWS(usuarioBean, tipoConsulta);
			break;
			
		case Enum_Con_Usuario.consultaEStatusAna:				
			usuario = usuarioDAO.ConEstatusAnalista(usuarioBean, tipoConsulta);
			break;
		case Enum_Con_Usuario.consultasolicitudes:				
			usuario = usuarioDAO.ConUsuarioAnalistaVirtual(usuarioBean, tipoConsulta);
			break;

		case Enum_Con_Usuario.consultaCoordinador:
			usuario = usuarioDAO.consultaCoordinador(usuarioBean, tipoConsulta);
			break;
			
			
		}

		return usuario;
	}
	
	/* Consulta si el Usuario se encuentra Logeado o Dentro de la Aplicacion
	 * Params: claveUsuario .- Clave del Usuario a Consultar
	 * Return: S .- Si se encuentra Logeado, N .- No se encuentra Logeado 
	 */
	
	
	public String consultaUsuarioLogeado(String claveUsuario){
		String estaLogeado = Enum_Usuario_Logeado.NO;
		if(sessionesUsuarioBean.getSesionesAplicacion().containsKey(claveUsuario.toUpperCase()) ||
		   sessionesUsuarioBean.getSesionesAplicacion().containsKey(claveUsuario.toLowerCase()) ||
		   sessionesUsuarioBean.getSesionesAplicacion().containsKey(claveUsuario)){
		estaLogeado = Enum_Usuario_Logeado.SI;
		}else{
			estaLogeado = Enum_Usuario_Logeado.NO;
		}
		return estaLogeado;
	}
	
	
	
	/* Elimina la Session del Usuario que se encuentra Logeado o Dentro de la Aplicacion
	 * Params: String claveUsuario .- Clave del Usuario a Eliminar
	 * Return: MensajeTransaccionBean con el Detalle de la Transaccion 
	 */
	public MensajeTransaccionBean eliminaSessionUsuario(String claveUsuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			//sessionesUsuarioBean.getSesionesAplicacion().remove(claveUsuario.toLowerCase());
			sessionesUsuarioBean.getSesionesAplicacion().remove(claveUsuario);
			System.out.println("eliminar "+sessionesUsuarioBean.getSesionesAplicacion().remove(claveUsuario));
			mensaje.setNumero(0);
			mensaje.setDescripcion("Sesión de Usuario Eliminada Exitosamente");
			mensaje.setNombreControl("usuarioID");
		}catch(Exception e){
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNombreControl("usuarioID");
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, UsuarioBean usuario){		
		List listaUsuarios = null;
		switch (tipoLista) {
		case Enum_Lis_Usuario.principal:		
			listaUsuarios = usuarioDAO.listaPrincipal(usuario,tipoLista);				
			break;		
		case Enum_Con_Usuario.consultaUsuPorNom:	
			listaUsuarios = usuarioDAO.consultaUsuarioPorNombre(usuario, tipoLista);
			break;	
		case Enum_Con_Usuario.consultaUsuPorNomExterna:	
			listaUsuarios = usuarioDAO.consultaUsuarioPorNombreExterna(usuario, Enum_Con_Usuario.consultaUsuPorNom);
			break;
		case Enum_Lis_Usuario.porSucursal:	
			listaUsuarios = usuarioDAO.listaporSucursal(usuario, tipoLista);
			break;
		case Enum_Lis_Usuario.usuarioGestor:	
			listaUsuarios = usuarioDAO.listaUsuarioGestor(usuario, tipoLista);
			break;
		case Enum_Lis_Usuario.usuarioGestProm:	
			listaUsuarios = usuarioDAO.listaUsuarioGestProm(usuario, tipoLista);
			break;	
	
		case Enum_Lis_Usuario.usuarioSupervisor:	
			listaUsuarios = usuarioDAO.listaUsuarioSupervisor(usuario, tipoLista);
			break;
		case Enum_Lis_Usuario.usuAsamGral:	
			listaUsuarios = usuarioDAO.lisUsuAsamGral(usuario, tipoLista);
			break;
		case Enum_Lis_Usuario.usuActBloq:		
			listaUsuarios = usuarioDAO.listaActBloq(usuario,tipoLista);				
			break;	
		case Enum_Lis_Usuario.usuvirtualAnalista:		
			listaUsuarios = usuarioDAO.listaPrincipal(usuario,tipoLista);				
			break;	
		case Enum_Lis_Usuario.usuRolAnalista:		
			listaUsuarios = usuarioDAO.listaPrincipal(usuario,tipoLista);				
			break;
		case Enum_Lis_Usuario.lisRolCoordinador:		
			listaUsuarios = usuarioDAO.listaPrincipal(usuario,tipoLista);				
			break;	
		case Enum_Lis_Usuario.lisConCorreo:
			listaUsuarios = usuarioDAO.listaConCorreos(usuario,tipoLista);
			break;
		}
		
		return listaUsuarios;
	}	

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Usuario.alta:
			mensaje = ValidaPassword(usuario,tipoTransaccion);
			break;				
		case Enum_Tra_Usuario.modificacion:
			mensaje = modificaUsuario(usuario);
			break;
		}
		return mensaje;
	}



	public MensajeTransaccionBean actualizaUsuario(int tipoActualizacion, UsuarioBean usuario){

		MensajeTransaccionBean mensaje = null;
		switch (tipoActualizacion) {
		case Enum_Act_Usuario.loginsFallidos:
			usuario = usuarioDAO.consultaPorClaveBDPrincipal(usuario, Enum_Con_Usuario.clave);
			usuarioDAO.getParametrosAuditoriaBean().setOrigenDatos(usuario.getOrigenDatos());
			mensaje = usuarioDAO.actualizaIntentosFallidos(usuario, tipoActualizacion);				
			break;	
		case Enum_Act_Usuario.actualizaBloDes:
			mensaje = usuarioDAO.actBloqDesbloqueoUsuario(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.actualizaCancel:
			// Cuando se cancela un usuario por segunda o mas veces se solicita un nuevo motivo y este se setea como el motivo de cancelacion
			if(usuario.getEsNuevoComenCance().equals("S")){
				usuario.setMotivoCancel(usuario.getMotivoNuevo());
			}
			mensaje = usuarioDAO.actCancelaUsuario(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.resetPassword:
			mensaje = ValidaPassword(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.act_statusSesionAct:
			mensaje = usuarioDAO.actStatusSesionActivoUsuario(usuario,Enum_Act_Usuario.act_statusSesionAct);
			break;
		case Enum_Act_Usuario.act_statusSesInact:
			mensaje = usuarioDAO.actStatusSesionInactivoUsuario(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.actualizaSesion:
			mensaje = usuarioDAO.actLimpiaSesion(usuario, tipoActualizacion);
			break;	
		case Enum_Act_Usuario.nuevoPassword:
			mensaje = ValidaPassword(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.reactivacionUsu:
			mensaje = usuarioDAO.actReactivaUsuario(usuario, tipoActualizacion);
			break;
		case Enum_Act_Usuario.actualizaEstatusAnalisis:
			mensaje = usuarioDAO.grabaActualizaEstAnalisis(usuario, tipoActualizacion);
			break;
		}
		return mensaje;
	}

	
	
	
	public  Object[] listaConsulta(int tipoLista){
		List listUsuario = null;
		switch(tipoLista){
			case Enum_Con_UsuarioA.usuarioActivo:
				listUsuario = usuarioDAO.consultaUsuarioActivo(tipoLista);
			break;
		}
		return listUsuario.toArray();
	}
	
	

	public MensajeTransaccionBean ValidaPassword(UsuarioBean usuario,int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String empresaID = "1";
		int maximoCaracterContra = 6;
		int numero = 0;
        int mayuscula=0;
        int minuscula=0;
        int caracterEspecial = 0;
        int validacion=1;
		String password= usuario.getContrasenia();
		
		ParametrosSisBean parametrosSisBean =  new  ParametrosSisBean();
		parametrosSisBean.setEmpresaID(empresaID);
		
		ParametrosSisBean parametrosSisResult = parametrosSisDAO.consultaParamConfigContra(parametrosSisBean, 23);
		
		if(parametrosSisResult != null){
			if(parametrosSisResult.getHabilitaConfPass().equals("S")){
			   maximoCaracterContra = Utileria.convierteEntero(parametrosSisResult.getCaracterMinimo());
			}
		}
		
		String pass[]=new String[password.length()];
		for(int i=0;i<password.length();i++){
			pass[i]=password.substring(i,i+1);
		
		}
		
		boolean may=false;
		boolean min=false;
		boolean numCar=false;
		boolean carEspecial =false;

		String mayusculas[] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","Ñ","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		String minusculas [] = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","ñ","o","p","q","r","s","t","u","v","w","x","y","z"};
		String numsCarac [] = {"0","1","2","3","4","5","6","7","8","9","!","#","%","&","/","(",")","=","?","¬","¿","+","±","*","[","]",
				"{","}","÷","$",".","_","-","|","°"};

		if (password.length() < maximoCaracterContra){
			mensaje.setNumero(999);
			mensaje.setDescripcion("La contraseña debe tener como mínimo " +  maximoCaracterContra + " caracteres");
			mensaje.setNombreControl("nuevaContra");
			return mensaje;
		}else
			if (password.length() >= maximoCaracterContra){
				// Validacion de caracteres Mayuscula Minimos requerida en una contraseña
				if (parametrosSisResult.getReqCaracterMayus().equals("S") && parametrosSisResult.getHabilitaConfPass().equals("S")){
					for(int i=0;i < password.length(); i++)  {	             
						// Cantidad de caracteres Mayuscula
						if (Character.isUpperCase(password.charAt(i))) {
							mayuscula++;
						}
					}
					
					if(mayuscula < Utileria.convierteEntero(parametrosSisResult.getCaracterMayus()) ){
						if(Utileria.convierteEntero(parametrosSisResult.getCaracterMayus()) > 1){
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterMayus()) + " Caracteres Alfabéticos Mayúscula.");
						}else{
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterMayus()) + " Caracter Alfabético Mayúscula.");
						}
											
						mensaje.setNumero(999);
						mensaje.setNombreControl("nuevaContra");
						return mensaje;
					}
					may=true;
				}else{
					do {
						int i;
						for(i=0;i<pass.length;i++){
							for(int j=0;j<mayusculas.length;j++){
								if(pass[i].equals(mayusculas[j])){;
								may=true;
								}
							}
						}
						if(i == pass.length && may == false){
							may=true;
							mensaje.setNumero(999);
							mensaje.setDescripcion("Se requiere al menos 1 Caracter Alfabético Mayúscula.");
							mensaje.setNombreControl("nuevaContra");
							return mensaje;
						}
	
					} while (may==false);
				}

				// Validacion de caracteres Minusculas Minimos requerida en una contraseña
				if (parametrosSisResult.getReqCaracterMinus().equals("S") && parametrosSisResult.getHabilitaConfPass().equals("S")){
					for(int i=0;i < password.length(); i++)  {	             
		               // Cantidad de caracteres minusculas
		               if (Character.isLowerCase(password.charAt(i))) {
		                   minuscula++;
		               }
					}
					
					if(minuscula < Utileria.convierteEntero(parametrosSisResult.getCaracterMinus()) ){
						if(Utileria.convierteEntero(parametrosSisResult.getCaracterMinus()) > 1){
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterMinus()) + " Caracteres Alfabéticos Minúscula.");
						}else{
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterMinus()) + " Caracter Alfabético Minúscula.");
						}
						
						mensaje.setNumero(999);
						mensaje.setNombreControl("nuevaContra");
						return mensaje;
					}
					min=true;
				}else {
					do {
						int i;
						for(i=0;i<pass.length;i++){
							for(int j=0;j<minusculas.length;j++){
								if(pass[i].equals(minusculas[j])){
									min=true;
								}
							}
						}
						if(i == pass.length && min == false){
							min=true;
							mensaje.setNumero(999);
							mensaje.setDescripcion("Se requiere al menos 1 Caracter Alfabético Minúscula.");
							mensaje.setNombreControl("nuevaContra");
							return mensaje;
						}
	
					} while (min==false);
				}
				
				// Validacion de caracteres Numericos y especiales Minimos requerida en una contraseña
				if (parametrosSisResult.getReqCaracterNumerico().equals("S") && parametrosSisResult.getHabilitaConfPass().equals("S")){
					for(int i=0;i < password.length(); i++)  {	             
		        	   // Cantidad de caracteres numero
		               if(Character.isDigit(password.charAt(i))) {
		                   numero ++;
		               }	
					}
					
					if(numero < Utileria.convierteEntero(parametrosSisResult.getCaracterNumerico()) ){
						if(Utileria.convierteEntero(parametrosSisResult.getCaracterNumerico()) > 1){
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterNumerico()) + " Caracteres Numéricos.");
						}else{
							mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterNumerico()) + " Caracter Numérico.");
						}
						
						mensaje.setNumero(999);
						mensaje.setNombreControl("nuevaContra");
						return mensaje;
					}
					numCar=true;
				}
				
				if (parametrosSisResult.getReqCaracterEspecial().equals("S") && parametrosSisResult.getHabilitaConfPass().equals("S")){
			           for(int i=0;i < password.length(); i++)  {	               
			               // Cantidad de caracteres especiales
			                if(!Character.isDigit(password.charAt(i)) && !Character.isLetter(password.charAt(i)) ) {
			                   caracterEspecial ++;
			               }
			           }
			           
			           if(caracterEspecial < Utileria.convierteEntero(parametrosSisResult.getCaracterEspecial()) ){
			        	   if(Utileria.convierteEntero(parametrosSisResult.getCaracterEspecial()) > 1){
			        		   mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterEspecial()) + " Caracteres Especiales.");
			        	   }else{
			        		   mensaje.setDescripcion("Se requiere al menos " + Utileria.convierteEntero(parametrosSisResult.getCaracterEspecial()) + " Caracter Especial.");
			        	   }
			        	   
							mensaje.setNumero(999);
							mensaje.setNombreControl("nuevaContra");
							return mensaje;
						}
			           carEspecial = true;
				}else {
					do {
						int i;
						for(i=0;i<pass.length;i++){
							for(int j=0;j<numsCarac.length;j++){
								if(pass[i].equals(numsCarac[j])){
									numCar=true;
									carEspecial=true;
								}
	
							}
						}
						if(i == pass.length && numCar == false){
							numCar=true;
							carEspecial=true;
							mensaje.setNumero(999);
							mensaje.setDescripcion("Se requiere al menos 1 Número o Caracter Especial.");
							mensaje.setNombreControl("nuevaContra");
							return mensaje;
						}
					} while (numCar==false);
				}
			}

		if(tipoActualizacion == Enum_Tra_Usuario.alta){
			if(may==true && min==true && numCar==true && carEspecial==true){	
				mensaje = altaUsuario(usuario);
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("Se requiere al menos 1 Caracter Alfabético Mayúscula, 1 Caracter Alfabético Minúscula, 1 Número o Caracter Especial.");
				mensaje.setNombreControl("nuevaContra");
			}	
		}else{
			if(may==true && min==true && numCar==true && carEspecial==true){
				//Confirmacion de contraseña
				 mensaje = usuarioDAO.validaUsuario(usuario, validacion);
				 if(mensaje.getNumero()!=0){
					 return mensaje;
				 }		
				//Encriptamos la Contraseña
				usuario.setContrasenia(SeguridadRecursosServicio.encriptaPass(usuario.getClave(), usuario.getContrasenia()));
				mensaje = usuarioDAO.resetPasswordUsuario(usuario, tipoActualizacion);
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("Se requiere al menos 1 Caracter Alfabético Mayúscula, 1 Caracter Alfabético Minúscula, 1 Número o Caracter Especial.");
				mensaje.setNombreControl("nuevaContra");
			}

		}
		return mensaje;
	}
	
	public  Object[] listaCombo(int tipoLista) {
		List listaUsuario= null;
		switch(tipoLista){
			case (Enum_Lis_Usuario.comboGestor):
				listaUsuario = usuarioDAO.comboGestor(tipoLista);
				break;
			case (Enum_Lis_Usuario.comboSupervisor):
				listaUsuario = usuarioDAO.comboGestor(tipoLista);
				break;
			case Enum_Lis_Usuario.lisRolAsesor:
				listaUsuario = usuarioDAO.listaPrincipal(new UsuarioBean(), tipoLista);
				break;
		}
		return listaUsuario.toArray();
	}
	
	/* lista usuarios para WS */
	public SP_SMSAP_Usuarios_DescargaResponse listaUsuariosWS(int tipoLista){
		SP_SMSAP_Usuarios_DescargaResponse respuestaLista = new SP_SMSAP_Usuarios_DescargaResponse();			
		List listaUsuarios;
		UsuarioBean usuarios;;
		
		listaUsuarios = usuarioDAO.listaUsuariosWS(tipoLista);
		
		if(listaUsuarios !=null){ 			
			try{
				for(int i=0; i<listaUsuarios.size(); i++){	
					usuarios = (UsuarioBean)listaUsuarios.get(i);
					
					respuestaLista.addUsuario(usuarios);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Sucursales para WS", e);
			}			
		}		
	 return respuestaLista;
	}
	
	//----------metodo para crear origenes de datos y paramtros de auditoria para acutlaizar fecha de ultimo acceso-----
	public MensajeTransaccionBean actualizaUltimoAcceso(UsuarioBean usuario){		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		UsuarioBean userBean = new UsuarioBean();
		//CONSULTA ORIGEN DE DATOS DEL USUARIO EN BD PRINCIPAL
		userBean = usuarioDAO.consultaPorClaveBDPrincipal(usuario, Enum_Con_Usuario.clave);	
		
		if(userBean != null){
			usuarioDAO.getParametrosAuditoriaBean().setOrigenDatos(userBean.getOrigenDatos());
			mensaje = usuarioDAO.actStatusSesionActivoUsuario(userBean, Enum_Act_Usuario.act_statusSesionAct);
			
			if(mensaje == null){
				mensaje = new MensajeTransaccionBean();
			}
		}		
		
		return mensaje;
	}
	
	
	
	
	
	
	

	//------------------ Geters y Seters ------------------------------------------------------	
	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

	public void setSessionesUsuarioBean(SessionesUsuarioBean sessionesUsuarioBean) {
		this.sessionesUsuarioBean = sessionesUsuarioBean;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public ParametrosSisDAO getParametrosSisDAO() {
		return parametrosSisDAO;
	}

	public void setParametrosSisDAO(ParametrosSisDAO parametrosSisDAO) {
		this.parametrosSisDAO = parametrosSisDAO;
	}

	
}
