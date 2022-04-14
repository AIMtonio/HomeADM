package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.List;

import soporte.bean.CompaniasBean;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.dao.CompaniasDAO;
import soporte.servicio.UsuarioServicio.Enum_Tra_Usuario;

public class CompaniasServicio extends BaseServicio {
	
	CompaniasDAO companiasDAO = null;	
	ParametrosSisServicio parametrosSisServicio=null;
	
	
	public static interface Enum_Tra_Companias {
		int alta = 1;
		int modificacion = 2;

	}
	
	public static interface Enum_Lis_Companias{
		int combo=1;
		int principal=2;
		
	}
	
	public static interface Enum_Con_Companias{
		int prefijo=1;
		int principal=2;
	}
	
	public Object[] listaCombo(int tipoLista, CompaniasBean companiasBean){
		List listaCompania = null;
		switch (tipoLista) {
			case Enum_Lis_Companias.combo:		
				listaCompania=  companiasDAO.listaCombo(companiasBean,tipoLista);				
				break;	

		}		
		return listaCompania.toArray();
	}
	
	public CompaniasBean consulta(int tipoLista, CompaniasBean companiasBean){
		CompaniasBean compania = null;
		switch (tipoLista) {
			case Enum_Con_Companias.prefijo:		
				compania=  companiasDAO.conPrefijo(companiasBean,tipoLista);				
				break;	
			case Enum_Con_Companias.principal:		
				compania=  companiasDAO.principal(companiasBean,tipoLista);				
				break;	

		}		
		return compania;
	}
	
	public MensajeTransaccionBean modificaCompanias(CompaniasBean companias) {
		MensajeTransaccionBean mensaje = null;
		mensaje = companiasDAO.modificaCompania(companias);
		if(mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR){
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean.setEmpresaID("1");
			parametrosSisBean=parametrosSisServicio.consulta(1, parametrosSisBean);
			parametrosSisBean.setMostrarPrefijo(companias.getMostrarPrefijo());
			parametrosSisServicio.grabaTransaccion(2, parametrosSisBean);
		}

		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaCompanias(CompaniasBean companias,int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = companiasDAO.altaCompania(companias);
		
		return mensaje;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CompaniasBean companiasBean) {
		System.out.println("tipoTransaccion"+tipoTransaccion);
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Companias.alta:
			mensaje = altaCompanias(companiasBean,tipoTransaccion);
			break;				
		case Enum_Tra_Companias.modificacion:
			mensaje = modificaCompanias(companiasBean);
			break;
		}
		return mensaje;
	}

	public List lista(int tipoLista, CompaniasBean compania){		
		List listaCompanias = null;
		switch (tipoLista) {
			case Enum_Lis_Companias.principal:		
				listaCompanias = companiasDAO.listaPrincipal(compania, tipoLista);				
				break;				
		}
		return listaCompanias;
	}

	public CompaniasDAO getCompaniasDAO() {
		return companiasDAO;
	}

	public void setCompaniasDAO(CompaniasDAO companiasDAO) {
		this.companiasDAO = companiasDAO;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	
	
}
