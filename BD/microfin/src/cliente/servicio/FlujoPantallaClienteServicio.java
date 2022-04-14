package cliente.servicio;

import general.servicio.BaseServicio;
import java.util.List;
import cliente.bean.FlujoPantallaClienteBean;
import cliente.dao.FlujoPantallaClienteDAO;


public class FlujoPantallaClienteServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	FlujoPantallaClienteDAO flujoPantallaClienteDAO = null;
//---------- Tipo de Consulta ----------------------------------------------------------------
//   _       _
//  / \  |  / \
//	| |  |  | | 
//	\_/ _|  \_/ solo se usa la lista, este servicio no tienen controlador solo se usa el dwr asi que tampoco tiene pantalla  
	public static interface Enum_Lis_FlujoPantalla {
		int Cliente = 1;
		int SolInvidual = 2;
		int SolGrupal = 3;
	
	}
	
	public FlujoPantallaClienteServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	
	
	public List<FlujoPantallaClienteBean> lista(int tipoLista, FlujoPantallaClienteBean flujoPantallaClienteBean){		
		List<FlujoPantallaClienteBean> listaFlujoPantalla = null;
		
		switch (tipoLista) {
			case Enum_Lis_FlujoPantalla.Cliente:		
				//System.out.println("flujoID:::::::::::::    " + flujoPantallaClienteBean.getTipoFlujoID());
				//System.out.println("Identificador:::::::::::      " + flujoPantallaClienteBean.getIdentificador());
				listaFlujoPantalla = flujoPantallaClienteDAO.listaCliente(flujoPantallaClienteBean);
				break;
			}		
		return listaFlujoPantalla;
	}

//	public List<FlujoPantallaClienteBean> reasignaSofiLocale(List<FlujoPantallaClienteBean> flujoCliente){
//		List<FlujoPantallaClienteBean> listaFlujoRetorno = null;
//		////bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
//		BufferedReader bufferedReader;		
//		String [] arregloIndice = null;
//		String [] arregloValor = null;
//		String [] arregloSplit = null;
//		FlujoPantallaClienteBean bean = null;
//		
//		String renglon;
//		
//		try {
//			try{
//				bufferedReader = new BufferedReader(new FileReader("/opt/tomcat6/webapps/microfin/WEB-INF/classes/messages.properties"));
//			}catch (Exception ex){
//				try{
//					bufferedReader = new BufferedReader(new FileReader("/opt/tomcat6/webapps/microfin/WEB-INF/classes/messages_scap.properties"));
//				}catch (Exception ex2){
//					try{
//						bufferedReader = new BufferedReader(new FileReader("/opt/tomcat6/webapps/microfin/WEB-INF/classes/messages_sofom.properties"));
//					}catch (Exception ex3){
//						throw new Exception("No se encontro ningun Archivo de mensajes."); 
//					}
//				}
//			}
//			
//			
//			for(int cont=0;(renglon = bufferedReader.readLine())!= null; cont++ ){
//				if(!renglon.trim().equals("")){
//					arregloSplit = renglon.split("=");
//					arregloValor[cont] 		=	"";
//					arregloIndice[cont] 	=	"";
//					switch(arregloSplit.length){
//						case 1:	arregloIndice[cont] 	=	arregloSplit[0];break;
//						case 2:	arregloValor[cont] 		=	arregloSplit[1];
//								arregloIndice[cont] 	=	arregloSplit[0];break;
//						default:
//					}
//					 
//				}
//			}
//			bufferedReader.close();
//			
//			int nItemsFlujoCliente 	= flujoCliente.size();
//			int nItemsSafiLocale	= 0;
//			
//			if(arregloIndice!=null){
//				nItemsSafiLocale	=arregloIndice.length;
//			}
//			Iterator<FlujoPantallaClienteBean> iter = flujoCliente.iterator();
//			while(iter.hasNext()){
//				for(int cont2=0;cont2 < nItemsSafiLocale;cont2++){
//					FlujoPantallaClienteBean siguiente = iter.next();
//					if(siguiente.getDesplegado().equals(arregloIndice[cont2])){
//						bean = new FlujoPantallaClienteBean();
//						if(!arregloValor[cont2].trim().equals("")){
//							bean.setDesplegado(arregloValor[cont2]);
//						}else{
//							bean.setDesplegado(siguiente.getDesplegado());
//						}
//						
//						bean.setOrden(siguiente.getOrden());
//						bean.setRecurso(siguiente.getRecurso());
//						listaFlujoRetorno.add(bean);
//						break;
//					}
//				}
//			}
//			
//		} catch (Exception e) {	
//			e.printStackTrace();
//			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo SafiLocale.");
//		}		
//		///aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//		return listaFlujoRetorno;
//	}

	public FlujoPantallaClienteDAO getFlujoPantallaClienteDAO() {
		return flujoPantallaClienteDAO;
	}





	public void setFlujoPantallaClienteDAO(
			FlujoPantallaClienteDAO flujoPantallaClienteDAO) {
		this.flujoPantallaClienteDAO = flujoPantallaClienteDAO;
	}

	
}
