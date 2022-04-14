package soporte.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import operacionesPDA.beanWS.response.SP_PDA_Sucursales_DescargaResponse;
import soporte.bean.SucursalesBean;
import soporte.dao.SucursalesDAO;


 

public class SucursalesServicio extends BaseServicio {

		//---------- Variables ------------------------------------------------------------------------
		SucursalesDAO sucursalesDAO = null;

		//---------- Tipod de Consulta ----------------------------------------------------------------
		public static interface Enum_Con_Sucursal{
			int principal = 1;
			int foranea = 2;
			int porCuentasAho = 3;
			int repTicket = 4;
			int corporativo = 5;
			int atencion = 6;
			int aportacion = 8;
		}

		public static interface Enum_Lis_Sucursal {
			int principal = 1;
			int combo = 2;
			int corporativo = 3;
			int foranea = 4;
			int sucursalesWS = 5;
		}
		public static interface Enum_Tra_Sucursal {
			int alta = 1;
			int modificacion = 2;

		}

		
		public SucursalesServicio () {
			super();
			// TODO Auto-generated constructor stub
		}
		
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SucursalesBean sucursal){
			MensajeTransaccionBean mensaje = null;
			switch (tipoTransaccion) {
				case Enum_Tra_Sucursal.alta:		
					mensaje = altaSucursal(sucursal);				
					break;				
				case Enum_Tra_Sucursal.modificacion:
					mensaje = modificaSucursal(sucursal);
					break;
				
			}
			return mensaje;
		}
		
		public MensajeTransaccionBean altaSucursal(SucursalesBean sucursal){
			MensajeTransaccionBean mensaje = null;
			mensaje = sucursalesDAO.altaSucursal(sucursal);		
			return mensaje;
		}

		public MensajeTransaccionBean modificaSucursal(SucursalesBean sucursal){
			MensajeTransaccionBean mensaje = null;
			mensaje = sucursalesDAO.modificaSucursal(sucursal);		
			return mensaje;
		}	
		
		public SucursalesBean consultaSucursal(int tipoConsulta, String numSucursal){
			
			SucursalesBean sucursales = null;
			switch (tipoConsulta) {
				case Enum_Con_Sucursal.principal:		
					sucursales = sucursalesDAO.consultaPrincipal(Integer.parseInt(numSucursal), tipoConsulta);				
					break;				
				case Enum_Con_Sucursal.foranea:
					sucursales = sucursalesDAO.consultaForanea(Integer.parseInt(numSucursal), tipoConsulta);
					break;
				case Enum_Con_Sucursal.corporativo:
					sucursales = sucursalesDAO.consultaForanea(Integer.parseInt(numSucursal), tipoConsulta);
					break;
				case Enum_Con_Sucursal.atencion:
					sucursales = sucursalesDAO.consultaForanea(Integer.parseInt(numSucursal), tipoConsulta);
					break;
				case Enum_Con_Sucursal.aportacion:
					sucursales = sucursalesDAO.consultaForanea(Integer.parseInt(numSucursal), tipoConsulta);
					break;

			}
			if(sucursales!=null){
				sucursales.setSucursalID(Utileria.completaCerosIzquierda(sucursales.getSucursalID(),SucursalesBean.LONGITUD_ID));
			}
			
			return sucursales;
		}
		
		public SucursalesBean consulta(SucursalesBean sucursal, int tipoConsulta){
			SucursalesBean sucursales = null;
			switch (tipoConsulta) {
				case Enum_Con_Sucursal.porCuentasAho:
					sucursales = sucursalesDAO.consulaNombreSuc(sucursal, tipoConsulta);
				     break;	
				case Enum_Con_Sucursal.repTicket:
					sucursales = sucursalesDAO.consultaRepTicket(sucursal, tipoConsulta);
					break;
			}
			return sucursales;
		}
		
		
		public List lista(int tipoLista, SucursalesBean sucursales){		
			List listaSucursales = null;
			switch (tipoLista) {
				case Enum_Lis_Sucursal.principal:		
					listaSucursales =  sucursalesDAO.listaSucursales(sucursales,tipoLista);				
					break;				
				case Enum_Lis_Sucursal.corporativo:		
					listaSucursales =  sucursalesDAO.listaSucursales(sucursales,tipoLista);				
					break;
				case Enum_Lis_Sucursal.foranea:		
					listaSucursales =  sucursalesDAO.listaSucursales(sucursales,tipoLista);				
					break;	
				case Enum_Lis_Sucursal.sucursalesWS:	
					listaSucursales =  sucursalesDAO.listaSucursales(sucursales,tipoLista);				
					break;	
			}
			return listaSucursales;
		}

		public Object[] listaCombo(int tipoLista, SucursalesBean sucursales){
			List listaSucursales = null;
			switch (tipoLista) {
				case Enum_Lis_Sucursal.combo:
					listaSucursales=  sucursalesDAO.listaCombo(sucursales,tipoLista);				
					break;
			}
			return listaSucursales.toArray();
		}
		
		/* lista sucursales para WS */
		public SP_PDA_Sucursales_DescargaResponse listaSucursalesWS(int tipoLista){
			SP_PDA_Sucursales_DescargaResponse respuestaLista = new SP_PDA_Sucursales_DescargaResponse();			
			List listaSucursales;
			SucursalesBean sucursal;;
			
			listaSucursales = sucursalesDAO.listaSucursalWS(tipoLista);
			
			if(listaSucursales !=null){ 			
				try{
					for(int i=0; i<listaSucursales.size(); i++){	
						sucursal = (SucursalesBean)listaSucursales.get(i);
						
						respuestaLista.addSucursal(sucursal);
					}
					
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Sucursales para WS", e);
				}			
			}		
		 return respuestaLista;
		}	


		//------------------ Geters y Seters ------------------------------------------------------	
		public void setSucursalesDAO(SucursalesDAO sucursalesDAO) {
			this.sucursalesDAO = sucursalesDAO;
		}


		public SucursalesDAO getSucursalesDAO() {
			return sucursalesDAO;
		}	
		

	}
