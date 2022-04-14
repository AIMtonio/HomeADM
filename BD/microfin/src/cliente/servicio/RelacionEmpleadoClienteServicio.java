package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cliente.bean.RelacionEmpleadoClienteBean;
import cliente.dao.RelacionEmpleadoClienteDAO;


public class RelacionEmpleadoClienteServicio extends BaseServicio {
	RelacionEmpleadoClienteDAO relacionEmpleadoClienteDAO = null;

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
		int relacionPersona = 1;
	}
	
	public RelacionEmpleadoClienteServicio(){
		super();
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RelacionEmpleadoClienteBean relacionesCliente, 
			String lisEmpleados, String lisClientes, String lisParentesco, String lisPuestos, String lisCURP, String lisRFC, String lisNomCliente){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Relaciones.alta:	
			case Enum_Tra_Relaciones.modificacion:
				mensaje = altaRelacionCliente(relacionesCliente, lisEmpleados, lisClientes, lisParentesco, lisPuestos, lisCURP, lisRFC, lisNomCliente, tipoTransaccion );				
				break;	
		
		}
		return mensaje;
	}
	
	/* controla relaciones*/
	public RelacionEmpleadoClienteBean consulta(int tipoConsulta,RelacionEmpleadoClienteBean bean){						
		RelacionEmpleadoClienteBean relacionBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Relaciones.relacion:		
				relacionBean = relacionEmpleadoClienteDAO.consultaRelacionado(bean, tipoConsulta);				
				break;
		}
			
		return relacionBean;
	}
	
	/* controla relaciones*/
	public RelacionEmpleadoClienteBean consultaRelacion(int tipoConsulta,RelacionEmpleadoClienteBean bean){						
		RelacionEmpleadoClienteBean relacionBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Relaciones.relacionPersona:		
				relacionBean = relacionEmpleadoClienteDAO.consultaRelacionadoEmp(bean, tipoConsulta);				
				break;
		}
			
		return relacionBean;
	}
	
	public MensajeTransaccionBean altaRelacionCliente(RelacionEmpleadoClienteBean relacionesCliente,
			String lisEmpleados, String lisClientes, String lisParentesco, String lisPuestos, String lisCURP, String lisRFC, String lisNomCliente, int transaccion){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaRelacionesCli = (ArrayList) creaListaRelacionesCli(relacionesCliente, lisEmpleados, lisClientes, lisParentesco, lisPuestos, lisCURP, lisRFC, lisNomCliente);

		if(transaccion == 1){
			mensaje = relacionEmpleadoClienteDAO.grabaListaRelaciones(relacionesCliente, listaRelacionesCli);
		}else{
			mensaje = relacionEmpleadoClienteDAO.modificaListaRelaciones(relacionesCliente, listaRelacionesCli);
		}
		
		return mensaje;
	}
	
	private List creaListaRelacionesCli(RelacionEmpleadoClienteBean relacionesCliente, 
			String lisEmpleados, String lisClientes, String lisParentesco, String lisPuestos, String lisCURP, String lisRFC, String lisNomCliente){

		StringTokenizer tokensClien = new StringTokenizer(lisClientes, ",");
		StringTokenizer tokensNomClien = new StringTokenizer(lisNomCliente, ",");
		StringTokenizer tokensParen = new StringTokenizer(lisParentesco, ",");
		StringTokenizer tokensPuest = new StringTokenizer(lisPuestos, ",");
		StringTokenizer tokensCURP = new StringTokenizer(lisCURP, ",");
		StringTokenizer tokensRFC = new StringTokenizer(lisRFC, ",");
		

		ArrayList listaRel = new ArrayList();
		
		
		RelacionEmpleadoClienteBean	relaciones;
		
		String lisClien[] = new String[tokensClien.countTokens()];
		String lisNomClien[] = new String[tokensNomClien.countTokens()];
		String lisParen[] = new String[tokensParen.countTokens()];		
		String lisRela[] = new String[tokensClien.countTokens()];
		String lisTipo[] = new String[tokensClien.countTokens()];
		String lisPuesto[] = new String[tokensPuest.countTokens()];
		String listaCURP[] = new String[tokensCURP.countTokens()];
		String listaRFC[] = new String[tokensRFC.countTokens()];
		
		int i=0;		
		while(tokensClien.hasMoreTokens()){
			lisClien[i] = String.valueOf(tokensClien.nextToken());
			i++;
		}
		
		i=0;		
		while(tokensNomClien.hasMoreTokens()){
			lisNomClien[i] = String.valueOf(tokensNomClien.nextToken());
			i++;
		}
		
		i = 0;
		while(tokensParen.hasMoreTokens()){
			lisParen[i] = String.valueOf(tokensParen.nextToken());
			i++;
		}
		
		i = 0;
		while(tokensPuest.hasMoreTokens()){
			lisPuesto[i] = String.valueOf(tokensPuest.nextToken());
			i++;
		}
		
		i = 0;
		while(tokensCURP.hasMoreTokens()){
			listaCURP[i] = String.valueOf(tokensCURP.nextToken());
			i++;
		}
		
		i = 0;
		while(tokensRFC.hasMoreTokens()){
			listaRFC[i] = String.valueOf(tokensRFC.nextToken());
			i++;
		}
		
		for (int x=0; x< lisClien.length; x++){
			if ( Integer.valueOf(lisClien[x]) == 0){
				lisRela[x] = String.valueOf(lisClien[x]);
				lisTipo[x] = String.valueOf(Enum_Tipo_Relaciones.empleado); // Entra a esta sección cuando el Relacionado no es Cliente
			}else{
					lisRela[x] = String.valueOf(lisClien[x]);					
					lisTipo[x] = String.valueOf(Enum_Tipo_Relaciones.cliente);
				
			}
		}

		for(int contador=0; contador < lisClien.length; contador++){
			relaciones = new RelacionEmpleadoClienteBean();

			relaciones.setEmpleadoID(relacionesCliente.getEmpleadoID());
			relaciones.setRelacionadoID(String.valueOf(lisClien[contador]));
			relaciones.setNombre(String.valueOf(lisNomClien[contador]));
			relaciones.setParentescoID(String.valueOf(lisParen[contador]));
			relaciones.setTipoRelacion(String.valueOf(lisTipo[contador]));
			relaciones.setPuestoID(String.valueOf(lisPuesto[contador]));
			relaciones.setCURP(String.valueOf(listaCURP[contador]));
			relaciones.setRFC(String.valueOf(listaRFC[contador]));
			
			
			relaciones.setNombreEmpleado(relacionesCliente.getNombreEmpleado());
			relaciones.setCURPEmpleado(relacionesCliente.getCURPEmpleado());
			relaciones.setRFCEmpleado(relacionesCliente.getRFCEmpleado());
			relaciones.setPuestoEmpleadoID(relacionesCliente.getPuestoEmpleadoID());
		
			listaRel.add(relaciones);
			
	
		}
		return listaRel;
	}
	
	public List lista(int tipoLista, RelacionEmpleadoClienteBean relacionesCliente){		
		List listaRelaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Relaciones.relacionesCliente:
				listaRelaciones =  relacionEmpleadoClienteDAO.listaRelacionesCliente(relacionesCliente,tipoLista);
			break;
		}
		return listaRelaciones;
	}
	
	public List listaRelaciones(int tipoLista, RelacionEmpleadoClienteBean relacionesCliente){		
		List listaRelaciones = null;
		switch (tipoLista) {
			case Enum_Lis_Relaciones.principal:
				listaRelaciones =  relacionEmpleadoClienteDAO.listaPrincipal(relacionesCliente,tipoLista);
			break;
		}
		return listaRelaciones;
	}


	public RelacionEmpleadoClienteDAO getRelacionEmpleadoClienteDAO() {
		return relacionEmpleadoClienteDAO;
	}


	public void setRelacionEmpleadoClienteDAO(RelacionEmpleadoClienteDAO relacionEmpleadoClienteDAO) {
		this.relacionEmpleadoClienteDAO = relacionEmpleadoClienteDAO;
	}

	
	
	
}
