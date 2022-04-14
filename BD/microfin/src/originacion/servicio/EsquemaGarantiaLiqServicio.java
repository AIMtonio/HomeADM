package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.EsquemaGarantiaLiqBean;
import originacion.dao.EsquemaGarantiaLiqDAO;

public class EsquemaGarantiaLiqServicio  extends BaseServicio{
	/* Declaracion de atributos de la clase */
	EsquemaGarantiaLiqDAO esquemaGarantiaLiqDAO = null;
	
	public EsquemaGarantiaLiqServicio() {
		super();
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_EsquemaGarantia {
		int alta	 		= 1;		// Alta Esquema de Garantia Liquida
		int actualizacion 	= 2;		// Actualización del Esquema de Garantía Líquida
		int baja 			= 3;		// Elimina Registros del Esquema de Garantía Líquida
		int altaFOGAFI 		= 4;		// Alta del Esquema de Garantia FOGAFI
		int actualizaFOGAFI = 5;		// Actualización del Esquema de Garantía FOGAFI
		int bajaFOGAFI 		= 6;		// Elimina Registros del Esquema de Garantía FOGAFI
		int bajaGeneral 	= 7;		// Elimina Registros de Garantía Líquida y FOGAFI
	}
	
	/*Enumera los tipo de lista */
	public static interface Enum_Lis_EsquemaGarantia {
		int principla  			= 1;
		int porProductoCredito = 2;		// lista esquemas por producto de credito, para grid
		int principalFOGAFI		= 3;	// Lista principal FOGAFI
		int porProdCredFOGAFI	= 4;	// Lista por Producto de Crédito FOGAFI
	}
	
	/*Enumera los tipo de consulta */
	public static interface Enum_Con_EsquemaGarantia {
		int principal 			= 1;
		int principalFOGAFI		= 2;
	}
	
	
	/* ========================== TRANSACCIONES ==============================  */

	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaGarantiaLiqBean bean){
		ArrayList listaEsquemasBean = (ArrayList) creaListaDetalle(bean);
		ArrayList listaEsquemasFOGAFIBean = (ArrayList) creaListaDetalleFOGAFI(bean);
		
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_EsquemaGarantia.alta:
				mensaje = esquemaGarantiaLiqDAO.procesarAlta(listaEsquemasBean);					
				break;
			case Enum_Tra_EsquemaGarantia.actualizacion:
				mensaje = esquemaGarantiaLiqDAO.actualiza(bean);					
				break;
			case Enum_Tra_EsquemaGarantia.baja:
				mensaje = esquemaGarantiaLiqDAO.baja(bean);		
				break;
			case Enum_Tra_EsquemaGarantia.altaFOGAFI:
				mensaje = esquemaGarantiaLiqDAO.procesarAltaFOGAFI(listaEsquemasFOGAFIBean);					
				break;
			case Enum_Tra_EsquemaGarantia.actualizaFOGAFI:
				mensaje = esquemaGarantiaLiqDAO.actualizaFOGAFI(bean);					
				break;
			case Enum_Tra_EsquemaGarantia.bajaFOGAFI:
				mensaje = esquemaGarantiaLiqDAO.bajaFOGAFI(bean);		
				break;
			case Enum_Tra_EsquemaGarantia.bajaGeneral:
				mensaje = bajaGeneral(bean);
				break;
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean bajaGeneral( EsquemaGarantiaLiqBean bean){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = esquemaGarantiaLiqDAO.actualiza(bean);
		mensaje = esquemaGarantiaLiqDAO.actualizaFOGAFI(bean);	
		mensaje = esquemaGarantiaLiqDAO.baja(bean);
		mensaje = esquemaGarantiaLiqDAO.bajaFOGAFI(bean);		

		
		return mensaje;
	}
	
	/* controla el tipo de lista */
	public List lista(EsquemaGarantiaLiqBean bean, int tipoLista){
		List listaEsquemas = null;
		switch (tipoLista) {			
			case Enum_Lis_EsquemaGarantia.porProductoCredito:
				listaEsquemas = esquemaGarantiaLiqDAO.listaPorProducCredito(bean, tipoLista);				
			break;	
			case Enum_Lis_EsquemaGarantia.porProdCredFOGAFI:
				listaEsquemas = esquemaGarantiaLiqDAO.listaPorProdCredFOGAFI(bean, tipoLista);				
			break;	
		}
		return listaEsquemas;	
	}

	
	/* consulta esquemas de garantia liquida */
	public EsquemaGarantiaLiqBean consulta(int tipoConsulta,EsquemaGarantiaLiqBean bean){						
		EsquemaGarantiaLiqBean esquemas = null;
		switch (tipoConsulta) {
			case Enum_Con_EsquemaGarantia.principal:		
				esquemas = esquemaGarantiaLiqDAO.consultaPrincipal(bean, tipoConsulta);				
				break;
			case Enum_Con_EsquemaGarantia.principalFOGAFI:		
				esquemas = esquemaGarantiaLiqDAO.consultaPrincipalFOGAFI(bean, tipoConsulta);				
				break;
		}
			
		return esquemas;
	}

	
	/* Arma la lista de beans */
	public List creaListaDetalle(EsquemaGarantiaLiqBean bean) {	
		
		// Lista GRID FOGA
		List<String> porcentaje		 = bean.getlPorcentaje();
		List<String> clasificacion	 = bean.getlClasificacion();
		List<String> limiteInferior	 = bean.getlLimiteInferior();
		List<String> limiteSuperior	 = bean.getlLimiteSuperior();
		List<String> bonificacion	 = bean.getlBonificaFOGA();		
		

		ArrayList listaDetalle = new ArrayList();
		EsquemaGarantiaLiqBean beanAux = null;	

		if(clasificacion != null){
			int tamanio = clasificacion.size();	
			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new EsquemaGarantiaLiqBean();
				
				// Se setean los valores del grid FOGA
				beanAux.setProducCreditoID(bean.getProducCreditoID());
				// Se setean los valores de la parametrización del Producto de Crédito
				// Campos FOGA
				beanAux.setGarantiaLiquida(bean.getGarantiaLiquida());
				beanAux.setLiberarGaranLiq(bean.getLiberarGaranLiq());
				beanAux.setBonificacionFOGA(bean.getBonificacionFOGA());
				beanAux.setDesbloqAutFOGA(bean.getDesbloqAutFOGA());
				
				// Campos FOGAFI
				beanAux.setGarantiaFOGAFI(bean.getGarantiaFOGAFI());
				beanAux.setModalidadFOGAFI(bean.getModalidadFOGAFI());
				beanAux.setBonificacionFOGAFI(bean.getBonificacionFOGAFI());
				beanAux.setDesbloqAutFOGAFI(bean.getDesbloqAutFOGAFI());
				
					
				beanAux.setClasificacion(clasificacion.get(i));
				beanAux.setLimiteInferior(limiteInferior.get(i));
				beanAux.setLimiteSuperior(limiteSuperior.get(i));
				beanAux.setPorcentaje(porcentaje.get(i));
				
				// Se evalua si la lista del Porcentaje de Bonifiaciones FOGA viene vacía.
				if(bonificacion == null){
					bean.setPorcBonificacionFOGA("0.00");
					
				}
				else{
					beanAux.setPorcBonificacionFOGA(bonificacion.get(i));
				}						
		
				listaDetalle.add(beanAux);				
				
			}
		}
		return listaDetalle;
		
	}
	
	
	/* Arma la lista de beans */
	public List creaListaDetalleFOGAFI( EsquemaGarantiaLiqBean bean) {	

		// Lista GRID FOGAFI
		List<String> porcentajeFOGAFI		= bean.getlPorcentajeFOGAFI();
		List<String> clasificacionFOGAFI	= bean.getlClasificacionFOGAFI();
		List<String> limiteInferiorFOGAFI	= bean.getlLimiteInferiorFOGAFI();
		List<String> limiteSuperiorFOGAFI	= bean.getlLimiteSuperiorFOGAFI();
		List<String> bonificacionFOGAFI	 	= bean.getlBonificaFOGAFI();

		ArrayList listaDetalle = new ArrayList();
		EsquemaGarantiaLiqBean beanAux = null;	

		if(clasificacionFOGAFI != null){
			int tamanio = clasificacionFOGAFI.size();	
			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new EsquemaGarantiaLiqBean();
				
				// Se setean los valores del grid FOGA
				beanAux.setProducCreditoID(bean.getProducCreditoID());
				// Se setean los valores de la parametrización del Producto de Crédito
				// Campos FOGA
				beanAux.setGarantiaLiquida(bean.getGarantiaLiquida());
				beanAux.setLiberarGaranLiq(bean.getLiberarGaranLiq());
				beanAux.setBonificacionFOGA(bean.getBonificacionFOGA());
				beanAux.setDesbloqAutFOGA(bean.getDesbloqAutFOGA());
				
				beanAux.setGarantiaFOGAFI(bean.getGarantiaFOGAFI());
				beanAux.setModalidadFOGAFI(bean.getModalidadFOGAFI());
				beanAux.setBonificacionFOGAFI(bean.getBonificacionFOGAFI());
				beanAux.setDesbloqAutFOGAFI(bean.getDesbloqAutFOGAFI());

				// Se setean los valores del grid FOGAFI
				beanAux.setClasificacionFOGAFI(clasificacionFOGAFI.get(i));
				beanAux.setLimiteInferiorFOGAFI(limiteInferiorFOGAFI.get(i));
				beanAux.setLimiteSuperiorFOGAFI(limiteSuperiorFOGAFI.get(i));
				beanAux.setPorcentajeFOGAFI(porcentajeFOGAFI.get(i));
				
				// Se evalua si la lista del Porcentaje de Bonifiaciones FOGAFI viene vacía.
				if(bonificacionFOGAFI == null){
					bean.setPorcBonificacionFOGAFI("0.00");
					
				}
				else{
					beanAux.setPorcBonificacionFOGAFI(bonificacionFOGAFI.get(i));
				}
					
	
		
				listaDetalle.add(beanAux);				
				
			}
		}
		return listaDetalle;
		
	}
	

	public EsquemaGarantiaLiqDAO getEsquemaGarantiaLiqDAO() {
		return esquemaGarantiaLiqDAO;
	}

	public void setEsquemaGarantiaLiqDAO(EsquemaGarantiaLiqDAO esquemaGarantiaLiqDAO) {
		this.esquemaGarantiaLiqDAO = esquemaGarantiaLiqDAO;
	}
}
