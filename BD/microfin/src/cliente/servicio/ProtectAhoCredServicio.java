package cliente.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cliente.bean.ProtecionAhorroCreditoBean;


import cliente.dao.ProtectAhoCredDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ProtectAhoCredServicio extends BaseServicio{
	
	ProtectAhoCredDAO protectAhoCredDAO =null;
	
	//------ TRANSACCIONES ----
	public static interface Enum_Tra_Proteccion {
		int alta 			= 1;		
		int actualiza		= 2;
	}
	
	//------ ACTUALIZACION ----
	public static interface Enum_Tra_Actualizacion {
		int autoriza		= 1;		
		int rechaza 		= 2;
	}
	
	//-------BAJAS--------	
	public static interface Enum_Baja_ProteccionAhorro{
		int principal	=1;		
	}
	public static interface Enum_Baja_ProteccionCredito{
		int principal	=1;		
	}	
	// ---- CONSULTAS ---
	public static interface Enum_Con_ProtecCuenta {
		int principal = 1;					
	}
	public static interface Enum_Con_ProtecCredito {
		int principal = 1;					
	}
	public static interface Enum_Con_AplicaProtec{
		int principal = 1;					
	}

	//---------LISTAS--------
	public static interface Enum_Lis_ProtecCtas{
		int listaCuentasProtec	=1;
		int ctasCteGridProtec	= 2;
	}
	
	public static interface Enum_Lis_ProtecCredito{
		int ListCreditosProtec	=2;		
	}
	
	public static interface Enum_Lis_ProtecBenefi{
		int listaBenefiCuenta	=1;
			
	}
		
	public static interface Enum_Lis_CliAplicaProtec{
			int proteccionAutorizada	=2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  int tipoActualizacion, ProtecionAhorroCreditoBean protecionAhorroCreditoBean ){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_Proteccion.alta:
				mensaje = protectAhoCredDAO.altaProteccion(protecionAhorroCreditoBean);
			break;
			case Enum_Tra_Proteccion.actualiza: 
				 mensaje = actualizaProteccion(tipoActualizacion, protecionAhorroCreditoBean);
			break;		 
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaProteccion(int tipoActualizacion, ProtecionAhorroCreditoBean protecionAhorroCreditoBean ){
		MensajeTransaccionBean mensaje = null;		
		ArrayList listaDatosGridCredAuto= (ArrayList) creaListaGridCreditos(protecionAhorroCreditoBean);
		ArrayList listaDatosGridCtasAuto= (ArrayList) creaListaGridCuentas(protecionAhorroCreditoBean);
		switch (tipoActualizacion) {
			case Enum_Tra_Actualizacion.autoriza:
				mensaje = protectAhoCredDAO.autorizaProteccionPro(protecionAhorroCreditoBean, listaDatosGridCtasAuto, listaDatosGridCredAuto, tipoActualizacion);
			break;
			case Enum_Tra_Actualizacion.rechaza: 
				mensaje = protectAhoCredDAO.autorizaRechazaProteccion(protecionAhorroCreditoBean, tipoActualizacion);
			break;
				 
		}
		return mensaje;
	}
	
	private List creaListaGridCreditos(ProtecionAhorroCreditoBean protecionAhorroCreditoBean){		
		StringTokenizer tokensBean = new StringTokenizer(protecionAhorroCreditoBean.getListaCreditos(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDatosCreditos = new ArrayList();
		ProtecionAhorroCreditoBean protecAhorroCreditoBean;
		
		while(tokensBean.hasMoreTokens()){
			protecAhorroCreditoBean = new ProtecionAhorroCreditoBean();			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");					
			protecAhorroCreditoBean.setCreditoID(tokensCampos[0]);
			tokensCampos[1] = tokensCampos[1].trim().replaceAll(",","").replaceAll("\\$","");
			protecAhorroCreditoBean.setMonAplicaCredito(tokensCampos[1]);			
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Creditos: Monto:"+ protecAhorroCreditoBean.getMonAplicaCredito()+" Credito:"+protecAhorroCreditoBean.getCreditoID());
			listaDatosCreditos.add(protecAhorroCreditoBean);			
		}		
		return listaDatosCreditos;
	 }
	
	 private List creaListaGridCuentas(ProtecionAhorroCreditoBean protecionAhorroCreditoBean){		
		StringTokenizer tokensBean = new StringTokenizer(protecionAhorroCreditoBean.getListaCuentas(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDatosCuentas = new ArrayList();
		ProtecionAhorroCreditoBean protecAhorroCreditoBean;
		
		while(tokensBean.hasMoreTokens()){
			protecAhorroCreditoBean = new ProtecionAhorroCreditoBean();			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			protecAhorroCreditoBean.setCuentaAhoID(tokensCampos[0]);	
			tokensCampos[1] = tokensCampos[1].trim().replaceAll(",","").replaceAll("\\$","");
			protecAhorroCreditoBean.setMonAplicaCuenta(tokensCampos[1]);
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Cuentas: Monto:"+ protecAhorroCreditoBean.getMonAplicaCuenta()+" Cuenta:"+protecAhorroCreditoBean.getCuentaAhoID());
			listaDatosCuentas.add(protecAhorroCreditoBean);			
		}		
		return listaDatosCuentas;
	 }
	 //-------Lista de Cuentas
	 public List listaProteccionCuenta(int tipoLista, ProtecionAhorroCreditoBean protecionAhorroCreditoBean){
		 List cuentasAhoLista = null;
		 switch (tipoLista) {
		 case  Enum_Lis_ProtecCtas.listaCuentasProtec:
			 cuentasAhoLista = protectAhoCredDAO.listaGridProteccionAhorro(protecionAhorroCreditoBean, tipoLista);
			 break;		     
		 case  Enum_Lis_ProtecCtas.ctasCteGridProtec:
			 cuentasAhoLista = protectAhoCredDAO.listaGridCuentasAhorro(protecionAhorroCreditoBean, tipoLista);
			 break;		         
		 }
		 return cuentasAhoLista;
	 }
	 
	 // Lista de Creditos
	 public List listaProetccionCredito(int tipoLista, ProtecionAhorroCreditoBean protecionAhorroCreditoBean){
			List cuentasAhoLista = null;			
			switch (tipoLista) {		    
		        case  Enum_Lis_ProtecCredito.ListCreditosProtec:
					cuentasAhoLista = protectAhoCredDAO.listaCreditoProtec(protecionAhorroCreditoBean, tipoLista);
		        break;
		        
			}
			return cuentasAhoLista;
		}
	 //----------Lista de Beneficiarios
	 public List listaProtecBeneficiarios(int tipoLista, ProtecionAhorroCreditoBean protecionAhorroCreditoBean){
			List cuentasAhoLista = null;
			switch (tipoLista) {		    
		        case  Enum_Lis_ProtecBenefi.listaBenefiCuenta:
					cuentasAhoLista = protectAhoCredDAO.listaBeneficiariosCte(protecionAhorroCreditoBean, tipoLista);
		        break;
		        
			}
			return cuentasAhoLista;
		}
	 //---------- Lista de Aplica Proteccion ---------
	 public List listaCliAplicaProteccion(int tipoLista, ProtecionAhorroCreditoBean protecionAhorroCreditoBean){
			List cuentasAhoLista = null;
			switch (tipoLista) {		    
		        case  Enum_Lis_CliAplicaProtec.proteccionAutorizada:
					cuentasAhoLista = protectAhoCredDAO.listaClientesProteccion(protecionAhorroCreditoBean, tipoLista);
		        break;
		        
			}
			return cuentasAhoLista;
		}
	 
	 
	public ProtecionAhorroCreditoBean consulta(int tipoConsulta, ProtecionAhorroCreditoBean protecionAhorroCreditoBean){
		ProtecionAhorroCreditoBean protecionAhorroCredito = null;
		switch(tipoConsulta){
			case Enum_Con_ProtecCuenta.principal:
				protecionAhorroCredito = protectAhoCredDAO.consultaPrincipal(protecionAhorroCreditoBean,tipoConsulta);
			break;

		}
		return protecionAhorroCredito;
		
	}
		
	//---------------------getter y setter--------------
	public ProtectAhoCredDAO getProtectAhoCredDAO() {
		return protectAhoCredDAO;
	}
	public void setProtectAhoCredDAO(ProtectAhoCredDAO protectAhoCredDAO) {
		this.protectAhoCredDAO = protectAhoCredDAO;
	}
	
	
	
	
}
