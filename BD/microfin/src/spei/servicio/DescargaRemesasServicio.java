package spei.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import spei.bean.DescargaRemesasBean;
import spei.bean.PagoRemesaSPEIBean;
import spei.dao.DescargaRemesasDAO;
import spei.servicio.PagoRemesaSPEIServicio.Enum_Lis_PagoRemesa;


		public class DescargaRemesasServicio extends BaseServicio {
			DescargaRemesasDAO descargaRemesasDAO = null;
			
			private DescargaRemesasServicio(){
				super();
			}
			public static interface Enum_Tra_SolDes {
				int alta 			= 1;
				
			}
			public static interface Enum_Con_SolDes{
				int principal = 1;
			
			}
			public static interface Enum_Lis_SolDes{
				int principal = 1;
				int gridSolDescargas = 2;
			
			}

			public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, HttpServletRequest request, DescargaRemesasBean descargaRemesasBean){
				MensajeTransaccionBean mensaje = null;
				switch(tipoTransaccion){
				case Enum_Tra_SolDes.alta:
					mensaje = altaSoliDes(descargaRemesasBean, tipoTransaccion);
					break;
				}

				return mensaje;
			}


			  
			
			public MensajeTransaccionBean altaSoliDes(DescargaRemesasBean descargaRemesasBean, int tipoTransaccion){
				MensajeTransaccionBean mensaje = null;
			    mensaje = descargaRemesasDAO.altaSolRemesas(descargaRemesasBean, tipoTransaccion);		
				return mensaje;
			}
			
			
			public DescargaRemesasBean consulta(int tipoConsulta, DescargaRemesasBean descargaRemesasBean){
				DescargaRemesasBean descargaRemesas = null;
				switch (tipoConsulta) {
				case Enum_Con_SolDes.principal:
					descargaRemesas = descargaRemesasDAO.consultaSolDescarga(descargaRemesasBean, tipoConsulta);
					break;
				}		
				return descargaRemesas;
			}
		
			
			public List lista(int tipoLista, DescargaRemesasBean descargaRemesas) {
				List listaSol = null;
				switch (tipoLista) {
				case Enum_Lis_SolDes.principal:
					listaSol = descargaRemesasDAO.listaSolDescargas(descargaRemesas, Enum_Lis_SolDes.principal);
					break;
					
				case Enum_Lis_SolDes.gridSolDescargas:
					listaSol = descargaRemesasDAO.listaSolDescargasGrid(descargaRemesas, Enum_Lis_SolDes.gridSolDescargas);
					break;
					
				}
				return listaSol;
			}
			
			public DescargaRemesasDAO getDescargaRemesasDAO() {
				return descargaRemesasDAO;
			}

			public void setDescargaRemesasDAO(DescargaRemesasDAO descargaRemesasDAO) {
				this.descargaRemesasDAO = descargaRemesasDAO;
			}
					

		
	}

