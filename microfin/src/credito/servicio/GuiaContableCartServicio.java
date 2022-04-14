package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import javax.servlet.http.HttpServletRequest;

import credito.bean.CuentasMayorCarBean;
import credito.bean.SubCtaSubClasifCartBean;
import credito.bean.SubCuentaIVACartBean;
import credito.bean.SubctaClasifCartBean;
import credito.bean.SubctaFondeadorCartBean;
import credito.bean.SubctaMonedaCartBean;
import credito.bean.SubctaProductCartBean;
import credito.bean.SubctaTipoCartBean;
import credito.dao.CuentasMayorCarDAO;
import credito.dao.SubCtaSubClasifCartDAO;
import credito.dao.SubCuentaIVACartDAO;
import credito.dao.SubctaClasifCartDAO;
import credito.dao.SubctaFondeadorCartDAO;
import credito.dao.SubctaMonedaCartDAO;
import credito.dao.SubctaProductCartDAO;
import credito.dao.SubctaTipoCartDAO;


public class GuiaContableCartServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------

	CuentasMayorCarDAO   cuentasMayorCarDAO  		= null;
	SubctaClasifCartDAO  subctaClasifCartDAO  		= null;
	SubctaMonedaCartDAO  subctaMonedaCartDAO  		= null;
	SubctaTipoCartDAO    subctaTipoCartDAO    		= null;
	SubctaProductCartDAO subctaProductCartDAO 		= null;
	SubCtaSubClasifCartDAO subCtaSubClasifCartDAO	= null;
	SubctaFondeadorCartDAO subctaFondeadorCartDAO	= null;
	SubCuentaIVACartDAO subCuentaIVACartDAO			= null;
	

	public GuiaContableCartServicio() {
		super();
	}


	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_GuiaContableCart {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_GuiaContableCart {
		int principal	= 1;
		int foranea 	= 2;
	}
	
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_GuiaContableCart {
		int principal 	= 1;
		int foranea 	= 2;
	}
	
	
	// --------- Consulta de SubctaFondeador
	public SubctaFondeadorCartBean consulta(int tipoConsulta, SubctaFondeadorCartBean subctaFondeadorCart){
			SubctaFondeadorCartBean subctaFondeadorCartBean = null;
				switch(tipoConsulta){
					case Enum_Con_GuiaContableCart.principal:
						  subctaFondeadorCartBean = subctaFondeadorCartDAO.consultaPrincipal(subctaFondeadorCart, tipoConsulta);
						  break;
				}
						
						return subctaFondeadorCartBean;
						
					}
	//---------- Metodo que Contiene las Transacciones---------------------------------------------------------------

	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionCM")):
					0;
				
	    int  tipoTransaccionCC = (request.getParameter("tipoTransaccionCC")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionCC")):
					0;
				
		int  tipoTransaccionMC = (request.getParameter("tipoTransaccionMC")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionMC")):
					0;
				
		int  tipoTransaccionTC = (request.getParameter("tipoTransaccionTC")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionTC")):
					0;
				
		int  tipoTransaccionPC = (request.getParameter("tipoTransaccionPC")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionPC")):
					0;
		int  tipoTransaccionSC = (request.getParameter("tipoTransaccionSC")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccionSC")):
					0;
		int  tipoTransaccionFD = (request.getParameter("tipoTransaccionFD")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccionFD")):
					0;
		int tipoTransaccionIA = (request.getParameter("tipoTransaccionIA")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccionIA")):
					0;

		//----------Transacciones de CuentasMayor---------------------------------------------------------------
		
		CuentasMayorCarBean cuentasMayorCar = new CuentasMayorCarBean();
		switch(tipoTransaccionCM){
			  case Enum_Tra_GuiaContableCart.alta:
				  cuentasMayorCar.setConceptoCarID(request.getParameter("conceptoCarID"));
				  cuentasMayorCar.setCuenta(request.getParameter("cuenta"));
				  cuentasMayorCar.setNomenclatura(request.getParameter("nomenclatura"));
				  cuentasMayorCar.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				  mensaje = cuentasMayorCarDAO.alta(cuentasMayorCar);
				  break;
				  
			  case Enum_Tra_GuiaContableCart.baja:
				  cuentasMayorCar.setConceptoCarID(request.getParameter("conceptoCarID"));
				  mensaje = cuentasMayorCarDAO.baja(cuentasMayorCar);
				  break;
				  
			  case Enum_Tra_GuiaContableCart.modifica:
				  cuentasMayorCar.setConceptoCarID(request.getParameter("conceptoCarID"));
				  cuentasMayorCar.setCuenta(request.getParameter("cuenta"));
				  cuentasMayorCar.setNomenclatura(request.getParameter("nomenclatura"));
				  cuentasMayorCar.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				  mensaje = cuentasMayorCarDAO.modifica(cuentasMayorCar);
				  break;
		}
		
		//----------Transacciones por tipo de clasificacion---------------------------------------------------------------

		SubctaClasifCartBean subctaClasifCart = new SubctaClasifCartBean();
		switch(tipoTransaccionCC){
		  	 case Enum_Tra_GuiaContableCart.alta:
		  		 subctaClasifCart.setConceptoCarID(request.getParameter("conceptoCarID2"));
		  		 subctaClasifCart.setConsumo(request.getParameter("consumo"));
		  		 subctaClasifCart.setComercial(request.getParameter("comercial"));
		  		 subctaClasifCart.setVivienda(request.getParameter("vivienda"));
		  		 mensaje = subctaClasifCartDAO.alta(subctaClasifCart);
			     break;
			  
		    case Enum_Tra_GuiaContableCart.baja:
		    	subctaClasifCart.setConceptoCarID(request.getParameter("conceptoCarID2"));
		    	mensaje = subctaClasifCartDAO.baja(subctaClasifCart);
			    break;
			  
		    case Enum_Tra_GuiaContableCart.modifica:
		    	 subctaClasifCart.setConceptoCarID(request.getParameter("conceptoCarID2"));
		  		 subctaClasifCart.setConsumo(request.getParameter("consumo"));
		  		 subctaClasifCart.setComercial(request.getParameter("comercial"));
		  		 subctaClasifCart.setVivienda(request.getParameter("vivienda"));
		  		 mensaje = subctaClasifCartDAO.modifica(subctaClasifCart);
			    break;
		}
		
		//----------Transacciones por fondeador---------------------------------------------------------------

		SubctaFondeadorCartBean subctaFondeadorCart = new SubctaFondeadorCartBean();
		switch(tipoTransaccionFD){
			 case Enum_Tra_GuiaContableCart.alta:
				 subctaFondeadorCart.setConceptoCarID(request.getParameter("conceptoCarID6"));
				 subctaFondeadorCart.setFondeoID(request.getParameter("fondeoID"));
				 subctaFondeadorCart.setSubCuenta(request.getParameter("subCuenta6"));
				  mensaje = subctaFondeadorCartDAO.alta(subctaFondeadorCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.baja:
				 subctaFondeadorCart.setConceptoCarID(request.getParameter("conceptoCarID6"));
				 subctaFondeadorCart.setFondeoID(request.getParameter("fondeoID"));
		    	 mensaje = subctaFondeadorCartDAO.baja(subctaFondeadorCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.modifica:
				 subctaFondeadorCart.setConceptoCarID(request.getParameter("conceptoCarID6"));
				 subctaFondeadorCart.setFondeoID(request.getParameter("fondeoID"));
				 subctaFondeadorCart.setSubCuenta(request.getParameter("subCuenta6"));
				  mensaje = subctaFondeadorCartDAO.modifica(subctaFondeadorCart);
			     break;
		}
		//----------Transacciones por tipo de moneda---------------------------------------------------------------

		SubctaMonedaCartBean subctaMonedaCart = new SubctaMonedaCartBean();
		switch(tipoTransaccionMC){
			 case Enum_Tra_GuiaContableCart.alta:
				  subctaMonedaCart.setConceptoCarID(request.getParameter("conceptoCarID4"));
				  subctaMonedaCart.setMonedaID(request.getParameter("monedaID"));
				  subctaMonedaCart.setSubCuenta(request.getParameter("subCuenta1"));
				  mensaje = subctaMonedaCartDAO.alta(subctaMonedaCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.baja:
		    	  subctaMonedaCart.setConceptoCarID(request.getParameter("conceptoCarID4"));
				  subctaMonedaCart.setMonedaID(request.getParameter("monedaID"));
		    	  mensaje = subctaMonedaCartDAO.baja(subctaMonedaCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.modifica:
		    	  subctaMonedaCart.setConceptoCarID(request.getParameter("conceptoCarID4"));
				  subctaMonedaCart.setMonedaID(request.getParameter("monedaID"));
				  subctaMonedaCart.setSubCuenta(request.getParameter("subCuenta1"));
				  mensaje = subctaMonedaCartDAO.modifica(subctaMonedaCart);
			     break;
		}
		
		/*//----------Transacciones por tipo de cartera---------------------------------------------------------------

		SubctaTipoCartBean subctaTipoCart = new SubctaTipoCartBean();
		switch(tipoTransaccionTC){
		     case Enum_Tra_GuiaContableCart.alta:
		    	 subctaTipoCart.setConceptoCarID(request.getParameter("conceptoCarID"));
		    	 subctaTipoCart.setCapital(request.getParameter("capital"));
		    	 subctaTipoCart.setInteres(request.getParameter("interes"));
		    	 mensaje = subctaTipoCartDAO.alta(subctaTipoCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.baja:
		    	 subctaTipoCart.setConceptoCarID(request.getParameter("conceptoCarID"));
		    	 mensaje = subctaTipoCartDAO.baja(subctaTipoCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.modifica:
		    	 subctaTipoCart.setConceptoCarID(request.getParameter("conceptoCarID"));
		    	 subctaTipoCart.setCapital(request.getParameter("capital"));
		    	 subctaTipoCart.setInteres(request.getParameter("interes"));
		    	 mensaje = subctaTipoCartDAO.modifica(subctaTipoCart);
			     break;
	    }*/
		
		//----------Transacciones por tipo de producto---------------------------------------------------------------

		SubctaProductCartBean subctaProductCart = new SubctaProductCartBean();
		switch(tipoTransaccionPC){
		     case Enum_Tra_GuiaContableCart.alta:
		    	 subctaProductCart.setConceptoCarID(request.getParameter("conceptoCarID3"));
		    	 subctaProductCart.setProducCreditoID(request.getParameter("producCreditoID"));
		    	 subctaProductCart.setSubCuenta(request.getParameter("subCuenta"));
		    	 mensaje = subctaProductCartDAO.alta(subctaProductCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.baja:
		    	 subctaProductCart.setConceptoCarID(request.getParameter("conceptoCarID3"));
		    	 subctaProductCart.setProducCreditoID(request.getParameter("producCreditoID"));
		    	 mensaje = subctaProductCartDAO.baja(subctaProductCart);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.modifica:
		    	 subctaProductCart.setConceptoCarID(request.getParameter("conceptoCarID3"));
		    	 subctaProductCart.setProducCreditoID(request.getParameter("producCreditoID"));
		    	 subctaProductCart.setSubCuenta(request.getParameter("subCuenta"));
		    	 mensaje = subctaProductCartDAO.modifica(subctaProductCart);
			     break;
	    }
		
		//----------Transacciones por tipo de producto---------------------------------------------------------------

		SubCtaSubClasifCartBean subCtaSubClasifCartBean = new SubCtaSubClasifCartBean();
		switch(tipoTransaccionSC){
		     case Enum_Tra_GuiaContableCart.alta:
		    	 subCtaSubClasifCartBean.setConceptoCarID(request.getParameter("conceptoCarID5"));
		    	 subCtaSubClasifCartBean.setProductoCartID(request.getParameter("producCreditoID5"));
		    	 subCtaSubClasifCartBean.setSubCuenta(request.getParameter("subCuenta5"));
		    	 mensaje = subCtaSubClasifCartDAO.alta(subCtaSubClasifCartBean);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.baja:
		    	 subCtaSubClasifCartBean.setConceptoCarID(request.getParameter("conceptoCarID5"));
		    	 subCtaSubClasifCartBean.setProductoCartID(request.getParameter("producCreditoID5"));
		    	 mensaje = subCtaSubClasifCartDAO.baja(subCtaSubClasifCartBean);
			     break;
			  
		     case Enum_Tra_GuiaContableCart.modifica:
		    	 subCtaSubClasifCartBean.setConceptoCarID(request.getParameter("conceptoCarID5"));
		    	 subCtaSubClasifCartBean.setProductoCartID(request.getParameter("producCreditoID5"));
		    	 subCtaSubClasifCartBean.setSubCuenta(request.getParameter("subCuenta5"));
		    	 mensaje = subCtaSubClasifCartDAO.modifica(subCtaSubClasifCartBean);
			     break;
	    }
		
		SubCuentaIVACartBean subCuentaIVACartBean = new SubCuentaIVACartBean();
		switch (tipoTransaccionIA) {
			case Enum_Tra_GuiaContableCart.alta:
				subCuentaIVACartBean.setConceptoCartID(request.getParameter("conceptoCarID7"));
				subCuentaIVACartBean.setPorcentaje(request.getParameter("porcentaje"));
				subCuentaIVACartBean.setSubCuenta(request.getParameter("subCuenta7"));
				mensaje = subCuentaIVACartDAO.alta(subCuentaIVACartBean);
				break;
			case Enum_Tra_GuiaContableCart.modifica:
				subCuentaIVACartBean.setConceptoCartID(request.getParameter("conceptoCarID7"));
				subCuentaIVACartBean.setPorcentaje(request.getParameter("porcentaje"));
				subCuentaIVACartBean.setSubCuenta(request.getParameter("subCuenta7"));
				mensaje = subCuentaIVACartDAO.modifica(subCuentaIVACartBean);
				break;
			case Enum_Tra_GuiaContableCart.baja:
				subCuentaIVACartBean.setConceptoCartID(request.getParameter("conceptoCarID7"));
				subCuentaIVACartBean.setPorcentaje(request.getParameter("porcentaje"));
				mensaje = subCuentaIVACartDAO.baja(subCuentaIVACartBean);
				break;
		}
		
		return mensaje;
		
	
	}	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubctaClasifCartDAO getSubctaClasifCartDAO() {
		return subctaClasifCartDAO;
	}
	public CuentasMayorCarDAO getCuentasMayorCarDAO() {
		return cuentasMayorCarDAO;
	}
	public void setCuentasMayorCarDAO(CuentasMayorCarDAO cuentasMayorCarDAO) {
		this.cuentasMayorCarDAO = cuentasMayorCarDAO;
	}
	public void setSubctaClasifCartDAO(SubctaClasifCartDAO subctaClasifCartDAO) {
		this.subctaClasifCartDAO = subctaClasifCartDAO;
	}
	public SubctaMonedaCartDAO getSubctaMonedaCartDAO() {
		return subctaMonedaCartDAO;
	}
	public void setSubctaMonedaCartDAO(SubctaMonedaCartDAO subctaMonedaCartDAO) {
		this.subctaMonedaCartDAO = subctaMonedaCartDAO;
	}
	public SubctaTipoCartDAO getSubctaTipoCartDAO() {
		return subctaTipoCartDAO;
	}
	public void setSubctaTipoCartDAO(SubctaTipoCartDAO subctaTipoCartDAO) {
		this.subctaTipoCartDAO = subctaTipoCartDAO;
	}
	public SubctaProductCartDAO getSubctaProductCartDAO() {
		return subctaProductCartDAO;
	}
	public void setSubctaProductCartDAO(SubctaProductCartDAO subctaProductCartDAO) {
		this.subctaProductCartDAO = subctaProductCartDAO;
	}
	public SubCtaSubClasifCartDAO getSubCtaSubClasifCartDAO() {
		return subCtaSubClasifCartDAO;
	}
	public void setSubCtaSubClasifCartDAO(
			SubCtaSubClasifCartDAO subCtaSubClasifCartDAO) {
		this.subCtaSubClasifCartDAO = subCtaSubClasifCartDAO;
	}

	public SubctaFondeadorCartDAO getSubctaFondeadorCartDAO() {
		return subctaFondeadorCartDAO;
	}

	public void setSubctaFondeadorCartDAO(
			SubctaFondeadorCartDAO subctaFondeadorCartDAO) {
		this.subctaFondeadorCartDAO = subctaFondeadorCartDAO;
	}
	
	public SubCuentaIVACartDAO getSubCuentaIVACartDAO() {
		return subCuentaIVACartDAO;
	}
	public void setSubCuentaIVACartDAO(SubCuentaIVACartDAO subCuentaIVACartDAO) {
		this.subCuentaIVACartDAO = subCuentaIVACartDAO;
	}
}
