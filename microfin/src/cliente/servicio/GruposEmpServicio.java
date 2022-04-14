package cliente.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.dao.GruposEmpDAO;
import cliente.servicio.DireccionesClienteServicio.Enum_Con_DireccionesCliente;
import soporte.servicio.SucursalesServicio.Enum_Lis_Sucursal;
import cliente.bean.DireccionesClienteBean;
import cliente.bean.GruposEmpBean;


public class GruposEmpServicio extends BaseServicio {
	
	private GruposEmpServicio(){
		super();
	}
	
	GruposEmpDAO gruposEmpDAO = null;

	public static interface Enum_Tra_GruposEmp {
		int alta = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Con_Empresa{
		int principal = 1;
		int foranea = 2;
	}
	
	public static interface Enum_Lis_Empresa {
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GruposEmpBean empresa){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_GruposEmp.alta:
			mensaje = gruposEmpDAO.altaGrupoEmp(empresa);
			break;
		case Enum_Tra_GruposEmp.modificacion:
			mensaje = gruposEmpDAO.actualizaGrupoEmp(empresa);
			break;
		}
		
		return mensaje;
	}
	
	
	public GruposEmpBean consulta(int tipoConsulta, String GrupoEmpID){
		GruposEmpBean empresa = null;
		switch (tipoConsulta) {
		case Enum_Con_Empresa.principal:		
			empresa = gruposEmpDAO.ConsultaPrincipal(Integer.parseInt(GrupoEmpID), Enum_Con_Empresa.principal);			
			break;				
		case Enum_Con_Empresa.foranea:
			empresa = gruposEmpDAO.consultaForanea(Integer.parseInt(GrupoEmpID), Enum_Con_Empresa.foranea);
			break;
		}
		if(empresa!=null){
			empresa.setGrupoEmpID(Utileria.completaCerosIzquierda(empresa.getGrupoEmpID(),5));
		}
		
		return empresa;
	}
	
		
		
	public List lista(int tipoLista, GruposEmpBean empresa){
		List grupoEmpLista = null;
		switch (tipoLista) {
		case Enum_Lis_Empresa.principal:
			grupoEmpLista = gruposEmpDAO.listaGrupoEmpresa(empresa, tipoLista);
			break;
			
		}
		return grupoEmpLista;
	}
	
	

	

	public void setGruposEmpDAO(GruposEmpDAO gruposEmpDAO){
		this.gruposEmpDAO = gruposEmpDAO; 		
	}
	
}
