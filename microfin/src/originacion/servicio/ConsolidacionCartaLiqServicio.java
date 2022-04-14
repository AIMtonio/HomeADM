package originacion.servicio;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import arrendamiento.reporte.CaratulaContratoControlador;
import credito.bean.CartaLiquidacionBean;
import credito.dao.CartaLiquidacionDAO;
import originacion.bean.AsignaCartaLiqBean;
import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.bean.SolicitudesArchivoBean;
import originacion.dao.AsignaCartaLiqDAO;
import originacion.dao.ConsolidacionCartaLiqDAO;
import originacion.dao.SolicitudArchivoDAO;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;

public class ConsolidacionCartaLiqServicio extends BaseServicio {

	ConsolidacionCartaLiqDAO consolidaCartaLiqDAO;
	CartaLiquidacionDAO cartaLiquidacionDAO;
	AsignaCartaLiqDAO asignaCartaLiqDAO;
	ParamGeneralesServicio paramGeneralesServicio = null;
	SolicitudArchivoDAO  solicitudArchivoDAO = null;

	private ConsolidacionCartaLiqServicio() {
		super();
	}

	public static interface Enum_Transaccion {
		int alta = 1;
		int grabaCarExt = 2;
		int actConsol		= 3;
		int actSolCre		= 4;
		int actOperativas	= 5;
	}

	public static interface Enum_TransaccionArchivo {
		int alta = 1;
	}

	public static interface Enum_Lis {
		int listaPrincipal = 1;
		int ayuda = 2;
	}

	public static interface Enum_Lis_Consolida {
		int principal=2;
	}

	public static interface Enum_Consulta {
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionCons,
			ConsolidacionCartaLiqBean consolidaCartaLiqBean, String detalles, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionCons) {
		case Enum_Transaccion.alta:
			mensaje = consolidaCartaLiqDAO.alta(consolidaCartaLiqBean, 0);
			//mensaje = grabaDetalle(consolidaCartaLiqBean, detalles);
			break;
		case Enum_Transaccion.grabaCarExt:
			mensaje = grabaDetalle(consolidaCartaLiqBean, detalles);
		case Enum_Transaccion.actConsol:
			mensaje = consolidaCartaLiqDAO.actualizaDatosConsol(consolidaCartaLiqBean,tipoTransaccionCons);
			break;
		case Enum_Transaccion.actSolCre:
//			entra a este flujo - 4
			mensaje = consolidaCartaLiqDAO.actualizaDatosSolic(consolidaCartaLiqBean,tipoTransaccionCons);
			if(mensaje.getNumero()==0 && tipoTransaccion != 2)
			mensaje = consolidaCartaLiqDAO.actualizaDatosTemp(consolidaCartaLiqBean,tipoTransaccionCons);
			if(mensaje.getNumero()==0)
				if(tipoTransaccion != 2)
					enviaRecursoAExp(consolidaCartaLiqBean, tipoTransaccion);
			break;
		case Enum_Transaccion.actOperativas:
			mensaje = consolidaCartaLiqDAO.actualizaDatosTemp(consolidaCartaLiqBean,tipoTransaccionCons);
			break;
		}
		return mensaje;
	}

	private MensajeTransaccionBean grabaDetalle(ConsolidacionCartaLiqBean consolidaCarLiqBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try {
			detalles = consolidaCarLiqBean.getDetalleCartas();
			List<ConsolidacionCartaLiqBean> listaDetalle = creaListaDetalle(
					consolidaCarLiqBean, detalles);
			mensaje = consolidaCartaLiqDAO.grabaDetalle(consolidaCarLiqBean,
					listaDetalle);
			;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}


	public MensajeTransaccionBean enviaAsigRecursoAExp(ConsolidacionCartaLiqBean consolidaCartaLiqBean) {
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionArchivoBean mensajeArchivoBean = null;
		AsignaCartaLiqBean asignaCartaLiqBean = null;
		SolicitudesArchivoBean solicitudesArchivoBean = null;
		ConsolidacionCartaLiqBean consolidaBean = null;
		try {
			asignaCartaLiqBean = new AsignaCartaLiqBean();
			asignaCartaLiqBean.setConsolidacionID(consolidaCartaLiqBean.getConsolidacionCartaID());
			asignaCartaLiqBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
			List<AsignaCartaLiqBean> lista = asignaCartaLiqDAO.listaInterna(asignaCartaLiqBean,2);
			String path = consolidaCartaLiqBean.getRecurso();

			for(AsignaCartaLiqBean asigCarta : lista)
			{
				CartaLiquidacionBean cartaLiqBean = new CartaLiquidacionBean();
				cartaLiqBean.setCreditoID(asigCarta.getCreditoID());
				cartaLiqBean = cartaLiquidacionDAO.consultaRecurso(cartaLiqBean,2);

				File source = new File(cartaLiqBean.getRecurso()); 
				File dest = new File(path+"Solicitudes/Solicitud"+consolidaCartaLiqBean.getSolicitudCreditoID()+"/");
				if(!dest.exists())
				{
					dest.mkdirs();
				}
				dest = new File(path+"Solicitudes/Solicitud"+consolidaCartaLiqBean.getSolicitudCreditoID()+"/"+source.getName());

			    InputStream is = null;
			    OutputStream os = null;
			    try {
			        is = new FileInputStream(source);
			        os = new FileOutputStream(dest);
			        byte[] buffer = new byte[1024];
			        int length;
			        while ((length = is.read(buffer)) > 0) {
			            os.write(buffer, 0, length);
			        }
			    }catch(Exception e)
			    {
					e.printStackTrace();
					mensaje = new MensajeTransaccionBean();
			    	mensaje.setNumero(-1);
					mensaje.setDescripcion("No se encontró el archivo "+path+cartaLiqBean.getRecurso()+"");
			    }

			    finally {
			        is.close();
			        os.close();
			    }

			    solicitudesArchivoBean = new SolicitudesArchivoBean();
			    solicitudesArchivoBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
			    solicitudesArchivoBean.setRecurso(cartaLiqBean.getRecurso());
			    solicitudesArchivoBean.setExtension((cartaLiqBean.getRecurso()+".").split("\\.")[1]);
			    solicitudesArchivoBean.setComentario("Carta de liquidacion consolidación de crédito");
			    solicitudesArchivoBean.setTipoDocumentoID("9995");
			    mensajeArchivoBean = solicitudArchivoDAO.altaArchivosSolCredito(solicitudesArchivoBean);

			    consolidaBean = new ConsolidacionCartaLiqBean();
			    consolidaBean.setCartaLiquidaId(asigCarta.getCartaLiquidaID());
			    consolidaBean.setConsolidacionCartaID(asigCarta.getConsolidacionID());
			    consolidaBean.setArchivoIDCarta(mensajeArchivoBean.getConsecutivoString());
			    consolidaCartaLiqDAO.modificaInternas(consolidaBean);

			    mensaje = new MensajeTransaccionBean();
		    	mensaje.setNumero(0);
				mensaje.setDescripcion("Cartas de Liquidación Guardadas Correctamente");
			}

		} catch (Exception e) {

		}
		return mensaje;
	}


	public MensajeTransaccionBean enviaRecursoAExp(ConsolidacionCartaLiqBean consolidaCartaLiqBean, int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		MensajeTransaccionArchivoBean mensajeArchivoBean = new MensajeTransaccionArchivoBean();
		AsignaCartaLiqBean asignaCartaLiqBean = null;
		SolicitudesArchivoBean solicitudesArchivoBean = null;
		ConsolidacionCartaLiqBean consolidaBean = null;
		FileOutputStream fos = null;
		String DocumentoArchCarta = "9996";
		String DocumentoArchPago = "9997";
		String rutaFinal = "";
		byte[] campoBlob = null;
		byte[] campoBlobPago = null;

		try {
			asignaCartaLiqBean = new AsignaCartaLiqBean();
			asignaCartaLiqBean.setConsolidacionID(consolidaCartaLiqBean.getConsolidacionCartaID());
			asignaCartaLiqBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());

			List<AsignaCartaLiqBean> lista = asignaCartaLiqDAO.listaInterna(asignaCartaLiqBean,2);

			List<AsignaCartaLiqBean> listaExternas = asignaCartaLiqDAO.listaExtTransicion(asignaCartaLiqBean,5);
			List<AsignaCartaLiqBean> listaExternasBlob = asignaCartaLiqDAO.listaExtTempBlob(asignaCartaLiqBean,3);


			String path = consolidaCartaLiqBean.getRecurso();
			//Internas no se mueven
			for(AsignaCartaLiqBean asigCarta : lista)
			{
				CartaLiquidacionBean cartaLiqBean = new CartaLiquidacionBean();
				cartaLiqBean.setCreditoID(consolidaCartaLiqBean.getRelacionado());
				cartaLiqBean = cartaLiquidacionDAO.consultaRecurso(cartaLiqBean,2);

				File source = new File(cartaLiqBean.getRecurso());
				File dest = new File(path+"Solicitudes/Solicitud"+consolidaCartaLiqBean.getSolicitudCreditoID()+"/");
				if(!dest.exists())
				{
					dest.mkdirs();
				}


			    solicitudesArchivoBean = new SolicitudesArchivoBean();
			    solicitudesArchivoBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
			    solicitudesArchivoBean.setRecurso(path+"Solicitudes/Solicitud"+consolidaCartaLiqBean.getSolicitudCreditoID()+"/");
			    solicitudesArchivoBean.setExtension("."+(cartaLiqBean.getRecurso()+".").split("\\.")[1]);
			    solicitudesArchivoBean.setComentario("Carta de liquidacion consolidación de crédito");
			    solicitudesArchivoBean.setTipoDocumentoID("9995");
			    if(tipoTransaccion != 2) {
			    	mensajeArchivoBean = solicitudArchivoDAO.altaArchivosSolCredito(solicitudesArchivoBean);
			    }

			    dest = new File(mensajeArchivoBean.getRecursoOrigen());
			    InputStream is = null;
			    OutputStream os = null;
			    try {
			        is = new FileInputStream(source);
			        os = new FileOutputStream(dest);
			        byte[] buffer = new byte[1024];
			        int length;
			        while ((length = is.read(buffer)) > 0) {
			            os.write(buffer, 0, length);
			        }
			    }catch(Exception e)
			    {
			    	mensaje.setNumero(-1);
					mensaje.setDescripcion(e.getMessage());

			    }

			    finally {
			    	try {
			        is.close();
			        os.close();
			    	}catch(Exception eio)
			    	{
			    		mensaje.setNumero(-1);
			    	}
			    }

			    consolidaBean = new ConsolidacionCartaLiqBean();
			    consolidaBean.setCartaLiquidaId(asigCarta.getCartaLiquidaID());
			    consolidaBean.setConsolidacionCartaID(asigCarta.getConsolidacionID());
			    consolidaBean.setArchivoIDCarta(mensajeArchivoBean.getConsecutivoString());
			    consolidaCartaLiqDAO.modificaInternas(consolidaBean);
			}

			for(AsignaCartaLiqBean detalle : listaExternas){
				detalle.setTipoDocumentoID(DocumentoArchCarta);
				rutaFinal = path+"Solicitudes/Solicitud"+consolidaCartaLiqBean.getSolicitudCreditoID()+"/";

				File SourceD = new File(rutaFinal);
				if(!SourceD.exists())
				{
					SourceD.mkdirs();
				}


				solicitudesArchivoBean = new SolicitudesArchivoBean();
				solicitudesArchivoBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
				solicitudesArchivoBean.setRecurso(rutaFinal);
				solicitudesArchivoBean.setExtension(detalle.getExtension());
				solicitudesArchivoBean.setComentario(detalle.getComentario());
				solicitudesArchivoBean.setTipoDocumentoID(DocumentoArchCarta);
				mensajeArchivoBean = solicitudArchivoDAO.altaArchivosSolCredito(solicitudesArchivoBean);
				detalle.setArchivoIDCarta(mensajeArchivoBean.getConsecutivoString());

				SourceD = new File(mensajeArchivoBean.getRecursoOrigen());
				fos = new FileOutputStream(SourceD);
				fos.write(detalle.getRecursoBlob());
				fos.close();

				//Comprobante de pago
				if(!detalle.getExtensionPago().trim().isEmpty()){
						AsignaCartaLiqBean ArchivoPago = new AsignaCartaLiqBean();
						ArchivoPago.setTipoDocumentoID(DocumentoArchPago);
						ArchivoPago.setSolicitudCreditoID(detalle.getSolicitudCreditoID());
						ArchivoPago.setTipoDocumentoID(DocumentoArchPago);
						ArchivoPago.setArchivoIDCarta(detalle.getArchivoIDPago());
						ArchivoPago.setComentario(detalle.getComentarioPago());

						ArchivoPago.setRecurso(rutaFinal);
						ArchivoPago.setExtension(detalle.getExtensionPago());

					    solicitudesArchivoBean = new SolicitudesArchivoBean();
					    solicitudesArchivoBean.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
					    solicitudesArchivoBean.setRecurso(ArchivoPago.getRecurso());
					    solicitudesArchivoBean.setExtension(detalle.getExtensionPago());
					    solicitudesArchivoBean.setComentario(detalle.getComentarioPago());
					    solicitudesArchivoBean.setTipoDocumentoID(ArchivoPago.getTipoDocumentoID());
					    mensajeArchivoBean = solicitudArchivoDAO.altaArchivosSolCredito(solicitudesArchivoBean);
					    detalle.setArchivoIDPago(mensajeArchivoBean.getConsecutivoString());

					    SourceD = new File(mensajeArchivoBean.getRecursoOrigen());
						fos = new FileOutputStream(SourceD);
				        fos.write(detalle.getRecursoBlobPago());
				        fos.close();
					}

				    detalle.setSolicitudCreditoID(consolidaCartaLiqBean.getSolicitudCreditoID());
				    //condicionar
				    if(tipoTransaccion != 2) {
				    	asignaCartaLiqDAO.modifica(detalle);
				    }
				}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	private List<ConsolidacionCartaLiqBean> creaListaDetalle(
			ConsolidacionCartaLiqBean consolidaCarLiqBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<ConsolidacionCartaLiqBean> listaDetalle = new ArrayList<ConsolidacionCartaLiqBean>();
		ConsolidacionCartaLiqBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new ConsolidacionCartaLiqBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos,
						"]");
				detalle.setSolicitudCreditoID(consolidaCarLiqBean
						.getSolicitudCreditoID());
				detalle.setAsignacionCartaID(tokensCampos[0]);
				detalle.setCasaComercialID(tokensCampos[1]);
				detalle.setMonto(tokensCampos[2]);
				detalle.setMontoAnterior(tokensCampos[3]);
				detalle.setFechaVigencia(tokensCampos[4]);
				detalle.setNombreCartaLiq(tokensCampos[5]);
				detalle.setRecurso(tokensCampos[6]);
				detalle.setExtension(tokensCampos[7]);
				detalle.setComentario(tokensCampos[8]);
				detalle.setArchivoIDCarta(tokensCampos[9]);
				detalle.setModificaArchCarta(tokensCampos[10]);
				detalle.setNombreComproPago(tokensCampos[11]);
				detalle.setRecursoPago(tokensCampos[12]);
				detalle.setExtensionPago(tokensCampos[13]);
				detalle.setComentarioPago(tokensCampos[14]);
				detalle.setArchivoIDPago(tokensCampos[15]);
				detalle.setModificaArchPago(tokensCampos[16]);
				detalle.setRutaFinal(tokensCampos[17]);
				detalle.setRutaFinalPago(tokensCampos[18]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public List<ConsolidacionCartaLiqBean> lista(int tipoLista,
			ConsolidacionCartaLiqBean consolidaCarLiqBean) {
		List<ConsolidacionCartaLiqBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis.listaPrincipal:
			lista = consolidaCartaLiqDAO.lista(consolidaCarLiqBean, tipoLista);
			break;
		}
		return lista;
	}

	public List listaCon(int tipoLista, ConsolidacionCartaLiqBean conolidacion){
		List listaConsolidacion = null;
		switch (tipoLista){
			case Enum_Lis_Consolida.principal:
				listaConsolidacion = consolidaCartaLiqDAO.listaPrincipal(conolidacion, tipoLista);
			break;
		}
		return listaConsolidacion;
	}

	public ConsolidacionCartaLiqBean consulta (int tipoConsulta, ConsolidacionCartaLiqBean consolidacion) {
		ConsolidacionCartaLiqBean consolidacionCartaLiqBean = null;
		switch (tipoConsulta){
			case Enum_Consulta.principal:
				consolidacionCartaLiqBean = consolidaCartaLiqDAO.consultaPrincipal(consolidacion, tipoConsulta);
				break;
		}
		return consolidacionCartaLiqBean;
	}

	public ConsolidacionCartaLiqDAO getConsolidaCartaLiqDAO() {
		return consolidaCartaLiqDAO;
	}

	public void setConsolidaCartaLiqDAO(
			ConsolidacionCartaLiqDAO consolidaCarLiqDAO) {
		this.consolidaCartaLiqDAO = consolidaCarLiqDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public CartaLiquidacionDAO getCartaLiquidacionDAO() {
		return cartaLiquidacionDAO;
	}

	public void setCartaLiquidacionDAO(CartaLiquidacionDAO cartaLiquidacionDAO) {
		this.cartaLiquidacionDAO = cartaLiquidacionDAO;
	}

	public AsignaCartaLiqDAO getAsignaCartaLiqDAO() {
		return asignaCartaLiqDAO;
	}

	public void setAsignaCartaLiqDAO(AsignaCartaLiqDAO asignaCartaLiqDAO) {
		this.asignaCartaLiqDAO = asignaCartaLiqDAO;
	}

	public SolicitudArchivoDAO getSolicitudArchivoDAO() {
		return solicitudArchivoDAO;
	}

	public void setSolicitudArchivoDAO(SolicitudArchivoDAO solicitudArchivoDAO) {
		this.solicitudArchivoDAO = solicitudArchivoDAO;
	}

}
