package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cliente.bean.RelacionClienteEmpleadoBean;
import cliente.dao.RelacionClienteEmpleadoDAO;

public class RelacionClienteEmpleadoServicio extends BaseServicio {
	RelacionClienteEmpleadoDAO relacionClienteDAO = null;

	public static interface Enum_Tra_Relaciones {
		int alta = 1;
		int modificacion = 2;
		int actualiza = 3;
	}
	
	public static interface Enum_Lis_Relaciones {
		int principal = 1;
		int foranea = 1;
		int relacionesCliente = 3;
	}
	public static interface Enum_Tipo_Relaciones {
		int cliente = 1;
		int empleado = 2;
	}
	
	public static interface Enum_Con_Relaciones {
		int relacion = 1;
	}
	
	public RelacionClienteEmpleadoServicio(){
		super();
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RelacionClienteEmpleadoBean relacionesCliente, 
			String lisEmpleados, String lisClientes, String lisParentesco){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Relaciones.alta:		
				mensaje = altaRelacionCliente(relacionesCliente, lisEmpleados, lisClientes, lisParentesco );				
				break;				
			case Enum_Tra_Relaciones.modificacion:
				//mensaje = modificaRelacionCliente(relacionesCliente);				
				break;		
		}
		return mensaje;
	}
	
	/* controla relaciones*/
	public RelacionClienteEmpleadoBean consulta(int tipoConsulta,RelacionClienteEmpleadoBean bean){						
		RelacionClienteEmpleadoBean relacionBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Relaciones.relacion:		
				relacionBean = relacionClienteDAO.consultaRelacionado(bean, tipoConsulta);				
				break;
		}
			
		return relacionBean;
	}
	
	public MensajeTransaccionBean altaRelacionCliente(RelacionClienteEmpleadoBean relacionesCliente,
			String lisEmpleados, String lisClientes, String lisParentesco){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaRelacionesCli = (ArrayList) creaListaRelacionesCli(relacionesCliente, lisEmpleados, lisClientes, lisParentesco);
		mensaje = relacionClienteDAO.grabaListaRelaciones(relacionesCliente, listaRelacionesCli );
		return mensaje;
	}
	
	private List creaListaRelacionesCli(RelacionClienteEmpleadoBean relacionesCliente, 
			String lisEmpleados, String lisClientes, String lisParentesco){
		StringTokenizer tokensEmple = new StringTokenizer(lisEmpleados, ",");
		StringTokenizer tokensClien = new StringTokenizer(lisClientes, ",");
		StringTokenizer tokensParen = new StringTokenizer(lisParentesco, ",");
		ArrayList listaRel = new ArrayList();
		
		RelacionClienteEmpleadoBean	relaciones;
		
		String lisEmple[] = new String[tokensEmple.countTokens()];
		String lisClien[] = new String[tokensClien.countTokens()];
		String lisParen[] = new String[tokensParen.countTokens()];		
		String lisRela[] = new String[tokensClien.countTokens()];
		String lisTipo[] = new String[tokensClien.countTokens()];
		
		int i=0;
		while(tokensEmple.hasMoreTokens()){
			lisEmple[i] = String.valueOf(tokensEmple.nextToken());
			i++;
		}
		i=0;
		while(tokensClien.hasMoreTokens()){
			lisClien[i] = String.valueOf(tokensClien.nextToken());
			i++;
		}
		i = 0;
		while(tokensParen.hasMoreTokens()){
			lisParen[i] = String.valueOf(tokensParen.nextToken());
			i++;
		}
		
		for (int x=0; x< lisEmple.length; x++){
			if ( Integer.valueOf(lisClien[x]) == 0){
				lisRela[x] = String.valueOf(lisEmple[x]);
				lisTipo[x] = String.valueOf(Enum_Tipo_Relaciones.empleado);
			}else{
				if(Integer.valueOf(lisEmple[x]) == 0){
					lisRela[x] = String.valueOf(lisClien[x]);
					lisTipo[x] = String.valueOf(Enum_Tipo_Relaciones.cliente);
				}
			}
		}
		
		for(int contador=0; contador < lisEmple.length; contador++){
			relaciones = new RelacionClienteEmpleadoBean();
			relaciones.setClienteID(relacionesCliente.getClienteID());
			relaciones.setRelacionadoID(String.valueOf(lisRela[contador]));
			relaciones.setParentescoID(String.valueOf(lisParen[contador]));
			relaciones.setTipoRelacion(String.valueOf(lisTipo[contador]));
			listaRel.add(relaciones);
		}
		return listaRel;
	}
	
	public List lista(int tipoLista, RelacionClienteEmpleadoBean relacionesCliente){		
		List listaRelaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Relaciones.relacionesCliente:
				listaRelaciones =  relacionClienteDAO.listaRelacionesCliente(relacionesCliente,tipoLista);
			break;
		}
		return listaRelaciones;
	}

	public RelacionClienteEmpleadoDAO getRelacionClienteDAO() {
		return relacionClienteDAO;
	}

	public void setRelacionClienteDAO(RelacionClienteEmpleadoDAO relacionClienteDAO) {
		this.relacionClienteDAO = relacionClienteDAO;
	}

	
	
}
