package bancaMovil.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import bancaMovil.bean.BAMCuentasOrigenBean;
import bancaMovil.dao.BAMCuentasOrigenDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class BAMCuentasOrigenServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	BAMCuentasOrigenDAO cuentasOrigenDAO = null;
	String codigo= "";

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CuentasOrigen {
		int principal 		= 1;
		int foranea 		= 2;
		
	}
	
	public static interface Enum_Lis_CuentasOrigen {
		int principal 		= 1;
		int listaFiltrada	= 2;
		
		
	}
	
	public static interface Enum_Tra_CuentasOrigen  {
		int alta		 = 1;
	}

	public BAMCuentasOrigenServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaListaBAMCuentasOrigen(int tipoTransaccion, BAMCuentasOrigenBean cuentaOrigen){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaCuentasAhorroID = (ArrayList) creaListaCuentasOrigen(cuentaOrigen);
		mensaje = cuentasOrigenDAO.grabaListaCuentasOrigen(cuentaOrigen, listaCuentasAhorroID);
		return mensaje;		
	}
	
	private List creaListaCuentasOrigen(BAMCuentasOrigenBean cuentaOrigen){
		StringTokenizer tokensCuenta = new StringTokenizer(cuentaOrigen.getCuentaAhoID(), ",");
		ArrayList<BAMCuentasOrigenBean> listaCuentasOrigen = new ArrayList();
		BAMCuentasOrigenBean cuentasOrigenBean;
		
		String montosInferior[] = new String[tokensCuenta.countTokens()];	
		
		int i=0;		
		
		while(tokensCuenta.hasMoreTokens()){
			montosInferior[i] = tokensCuenta.nextToken();
			i++;
		}
		
		for(int contador=0; contador < montosInferior.length; contador++){		
			cuentasOrigenBean = new BAMCuentasOrigenBean();	
			cuentasOrigenBean.setCuentaAhoID(montosInferior[contador]);
			cuentasOrigenBean.setEstatus("A");
			cuentasOrigenBean.setClienteID(cuentaOrigen.getClienteID());
			listaCuentasOrigen.add(cuentasOrigenBean);
		}
		return listaCuentasOrigen;
	}
	
	
	public BAMCuentasOrigenBean consultaCuentasOrigen(int tipoConsulta, String numeroCuenta, String numeroCliente){
		BAMCuentasOrigenBean cuenta = null;
		switch (tipoConsulta) {
			case Enum_Con_CuentasOrigen .principal:		
				cuenta = cuentasOrigenDAO.consultaPrincipal(Utileria.convierteLong(numeroCuenta), tipoConsulta);				
				break;
			case Enum_Con_CuentasOrigen.foranea:
				cuenta = cuentasOrigenDAO.consultaVerificacionCuenta(Utileria.convierteLong(numeroCuenta), 
																		tipoConsulta,Utileria.convierteEntero(numeroCliente));		
		}
		return cuenta;
	}
	
	public List lista(int tipoLista, BAMCuentasOrigenBean cuentasOrigen){		
		List listaBAMCuentasOrigen = null;
		switch (tipoLista) {
			case Enum_Lis_CuentasOrigen.principal:		
				listaBAMCuentasOrigen = cuentasOrigenDAO.listaPrincipal(cuentasOrigen, tipoLista);				
				break;
			case Enum_Lis_CuentasOrigen.listaFiltrada:		
				listaBAMCuentasOrigen = cuentasOrigenDAO.listaFiltroCuentas(cuentasOrigen, tipoLista);				
				break;
		}
		return listaBAMCuentasOrigen;
	}	
	
	public void setBAMCuentasOrigenDAO(BAMCuentasOrigenDAO cuentasOrigenDAO) {
		this.cuentasOrigenDAO = cuentasOrigenDAO;
	}

	public BAMCuentasOrigenDAO getBAMCuentasOrigenDAO() {
		return cuentasOrigenDAO;
	}
}
