package originacion.servicio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.commons.codec.binary.Base64;

import credito.bean.CartaLiquidacionBean;
import credito.dao.CartaLiquidacionDAO;
import originacion.bean.AsignaCartaLiqBean;
import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.dao.AsignaCartaLiqDAO;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.SistemaLogging;

public class AsignaCartaLiqServicio extends BaseServicio{

	AsignaCartaLiqDAO asignaCartaLiqDAO;
	ConsolidacionCartaLiqServicio consolidacionCartaLiqServicio;
	CartaLiquidacionDAO cartaLiquidacionDAO;
	ParamGeneralesServicio paramGeneralesServicio = null;

	private AsignaCartaLiqServicio(){
		super();
	}

	public static interface Enum_Transaccion {
		int alta 			= 1;
		int modificacion 	= 2;
		int CartasExtGridN	= 3; //Cartas nuevas Liq
		int CartasExtGrid	= 4;
	}

	public static interface Enum_TransaccionArchivo {
		int alta = 1;
	}

	public static interface Enum_Lis{
		int listaExtS 	= 3; //Listas Externas con solicitud
		int listaExt 	= 1; //Lista Externas sin Solicitud
		int listaInternas = 2;
		int listaInternasTemp = 4;
	}

	public static interface Enum_Consulta {
		int principal = 1;
		int foranea = 2;
		int solCred = 3;
	}

	/**
	 * Método que graba la transacción.
	 * @param tipoTransaccion : 1.- Alta/Registro.
	 * @param cartaLiqBean : Clase bean que contiene los valores de la Carta de Liquidacion.
	 * @param detalles : Uso futuro.
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AsignaCartaLiqBean cartaLiqBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDetalle = null;
		switch (tipoTransaccion) {
			case Enum_Transaccion.alta://Alta de una nueva consolidacion
				mensaje = asignaCartaLiqDAO.alta(cartaLiqBean, parametrosAuditoriaBean.getNumeroTransaccion());
				break;
			case Enum_Transaccion.CartasExtGridN://3
				listaDetalle = (ArrayList) this.creaListaDetalle(cartaLiqBean, detalles);
				mensaje = asignaCartaLiqDAO.grabaDetalleGridExt(cartaLiqBean, listaDetalle);
			case Enum_Transaccion.CartasExtGrid://4
				listaDetalle = (ArrayList) this.creaListaDetalleSol(cartaLiqBean, detalles);
				mensaje = asignaCartaLiqDAO.grabaDetalleGridExt(cartaLiqBean, listaDetalle);
		}
		return mensaje;
	}


	/**
	 * Graba las Cartas de Liquidacion Asignadas a la Solicitud de Credito
	 * @param cartaLiqBean : Clase bean que contiene los valores de la Asignacion de Cartas
	 * @param detalles : Cadena con la lista de las Asignaciones a pasar en la clase bean.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean grabaDetalle(AsignaCartaLiqBean cartaLiqBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			detalles = cartaLiqBean.getDetalleCartas();
			List<AsignaCartaLiqBean> listaDetalle = creaListaDetalle(cartaLiqBean, detalles);
			//mensaje=asignaCartaLiqDAO.grabaDetalle(cartaLiqBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}

	public MensajeTransaccionBean grabaDetalleInt(AsignaCartaLiqBean cartaLiqBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			List<AsignaCartaLiqBean> listaDetalle = creaListaDetalleInt(cartaLiqBean, detalles);
			mensaje=asignaCartaLiqDAO.grabaDetalleInt(cartaLiqBean, listaDetalle);
			if(mensaje.getNumero()==0 && listaDetalle.size() > 0)
			{
				if(cartaLiqBean.getSolicitudCreditoID()!=null && Integer.valueOf(cartaLiqBean.getSolicitudCreditoID())>0)
				{
					ConsolidacionCartaLiqBean consolidacionCartaLiqBean = new ConsolidacionCartaLiqBean();
					consolidacionCartaLiqBean.setSolicitudCreditoID(cartaLiqBean.getSolicitudCreditoID());
					consolidacionCartaLiqBean.setConsolidacionCartaID(cartaLiqBean.getConsolidacionID());
					consolidacionCartaLiqBean.setRecurso(cartaLiqBean.getRutaArchivos());
					mensaje = consolidacionCartaLiqServicio.enviaAsigRecursoAExp(consolidacionCartaLiqBean);
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}


	/**
	 * Método para crear la lista de detalles.
	 * @param detalles : Cadena de la lista de las referencias separados por corchetes.
	 * @return List : Lista con los beans que contiene los datos de las referencias de pagos.
	 * @author avelasco
	 */
	private List<AsignaCartaLiqBean> creaListaDetalle(AsignaCartaLiqBean cartaLiqBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<AsignaCartaLiqBean> listaDetalle = new ArrayList<AsignaCartaLiqBean>();
		AsignaCartaLiqBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AsignaCartaLiqBean();
				stringCampos = tokensBean.nextToken();
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setSolicitudCreditoID(cartaLiqBean.getSolicitudCreditoID());
				detalle.setAsignacionCartaID(tokensCampos[0]);
				detalle.setCasaComercialID(tokensCampos[1]);
				detalle.setMonto(tokensCampos[2]);
				detalle.setMontoAnterior(tokensCampos[3]);
				detalle.setFechaVigencia(tokensCampos[4]);
				detalle.setNombreCartaLiq(tokensCampos[5]);
				detalle.setRecursoPath(tokensCampos[6]);
				detalle.setRecurso(tokensCampos[6]);
				detalle.setRecursoBlob(getArchivoB64(detalle.getRecursoPath()));
				detalle.setExtension(tokensCampos[7]);
				detalle.setComentario(tokensCampos[8]);
				detalle.setArchivoIDCarta(tokensCampos[9]);
				detalle.setModificaArchCarta(tokensCampos[10]);
				detalle.setNombreComproPago(tokensCampos[11]);

				detalle.setRecursoPago(tokensCampos[12]);
				detalle.setRecursoBlobPago(getArchivoB64(detalle.getRecursoPago()));

				detalle.setExtensionPago(tokensCampos[13]);
				detalle.setComentarioPago(tokensCampos[14]);
				detalle.setArchivoIDPago(tokensCampos[15]);
				detalle.setModificaArchPago(tokensCampos[16]);
				detalle.setRutaFinal(tokensCampos[17]);
				detalle.setRutaFinalPago(tokensCampos[18]);

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}


	private List<AsignaCartaLiqBean> creaListaDetalleSol(AsignaCartaLiqBean cartaLiqBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<AsignaCartaLiqBean> listaDetalle = new ArrayList<AsignaCartaLiqBean>();
		AsignaCartaLiqBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AsignaCartaLiqBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setSolicitudCreditoID(cartaLiqBean.getSolicitudCreditoID());
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
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	/**
	 * Método para crear la lista de detalles.
	 * @param detalles : Cadena de la lista de las referencias separados por corchetes.
	 * @return List : Lista con los beans que contiene los datos de las referencias de pagos.
	 * @author avelasco
	 */
	private List<AsignaCartaLiqBean> creaListaDetalleInt(AsignaCartaLiqBean cartaLiqBean, String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<AsignaCartaLiqBean> listaDetalle = new ArrayList<AsignaCartaLiqBean>();
		AsignaCartaLiqBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new AsignaCartaLiqBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

				detalle.setSolicitudCreditoID(cartaLiqBean.getSolicitudCreditoID());
				detalle.setConsolidacionID(cartaLiqBean.getConsolidacionID());
				detalle.setCartaLiquidaID(tokensCampos[0]);
				detalle.setCreditoID(tokensCampos[1]);
				detalle.setFechaVigencia(tokensCampos[2]);
				detalle.setMonto(tokensCampos[3]);
				detalle.setRecurso(tokensCampos[4]);
				detalle.setRecursoPath(tokensCampos[5]);
				detalle.setRecursoBlob(getArchivoB64(detalle.getRecursoPath()));

				listaDetalle.add(detalle);
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public byte[] getArchivoB64(String recursoPath)
	{
		byte[] fileContent = null;
		   // initialize string buffer to hold contents of file
		   StringBuffer fileContentStr = new StringBuffer("");
		   BufferedReader reader = null;

		   try {
		        // initialize buffered reader
			reader = new BufferedReader(new FileReader(recursoPath));
			String line = null;
		        // read lines of file
			while ((line = reader.readLine()) != null) {
		           //append line to string buffer
		           fileContentStr.append(line).append("\n");
			}
		        // convert string to byte array
			fileContent = fileContentStr.toString().trim().getBytes();
		   } catch (IOException e) {
			return null;
		   } finally {
			if (reader != null) {
		           try {
					reader.close();
				} catch (IOException e) {
					return null;
				}
			}
		   }
		return fileContent;
	}


	/**
	 * Método que lista las referencias de pago por tipo de instrumento y tipo de canal.
	 * @param tipoLista : Tipo de lista. 1.- Principal.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @return Lista de clases bean ReferenciasPagosBean, para enlistar las referencias de pago.
	 * @author avelasco
	 */
	public List<AsignaCartaLiqBean> lista(int tipoLista, AsignaCartaLiqBean cartaLiqBean){
		List<AsignaCartaLiqBean> lista = null;
		switch (tipoLista) {
		case Enum_Lis.listaExtS:
			lista = asignaCartaLiqDAO.listaExtTemp(cartaLiqBean, tipoLista);
			break;
		case Enum_Lis.listaExt:
			lista = asignaCartaLiqDAO.lista(cartaLiqBean, tipoLista);
			break;
		case Enum_Lis.listaInternas:
			lista = asignaCartaLiqDAO.listaInterna(cartaLiqBean, tipoLista);
			completaRecursoCartaLiq(lista);
			break;
		case Enum_Lis.listaInternasTemp:
			lista = asignaCartaLiqDAO.listaInterna(cartaLiqBean, tipoLista);
			completaRecursoCartaLiq(lista);
			break;
		}
		return lista;
	}


	private void completaRecursoCartaLiq(List<AsignaCartaLiqBean> lista)
	{
		CartaLiquidacionBean cartaBean =  null;
		for(AsignaCartaLiqBean asig : lista)
		{
		  cartaBean = new CartaLiquidacionBean();
		  cartaBean.setCreditoID(asig.getCreditoID());
		  cartaBean = cartaLiquidacionDAO.consultaRecurso(cartaBean,2);
		  if(cartaBean!=null)
		  {
		  asig.setRecurso(cartaBean.getRecurso());
		  asig.setArchivoIDCarta(cartaBean.getArchivoIdCarta());
		  }
		  else
		  {
			  asig.setRecurso("/");
			  asig.setArchivoIDCarta("0");
			  asig.setCartaLiquidaID("0");
		  }
		}
	}

	/**
	 * Método para la consulta de la consolidación
	 **/
	public AsignaCartaLiqBean consulta(int tipoConsulta, AsignaCartaLiqBean asignaCarta){
		AsignaCartaLiqBean asignaCartaBean = null;
		switch (tipoConsulta){
			case Enum_Consulta.principal:
				asignaCartaBean = asignaCartaLiqDAO.consultaPrincipal(asignaCarta,tipoConsulta);
			case Enum_Consulta.solCred:
				asignaCartaBean = asignaCartaLiqDAO.consultaPrincipal(asignaCarta,tipoConsulta);
		}
		return asignaCartaBean;
	}


	public AsignaCartaLiqDAO getAsignaCartaLiqDAO(){
		return asignaCartaLiqDAO;
	}

	public void setAsignaCartaLiqDAO(AsignaCartaLiqDAO asignaCartaLiqDAO){
		this.asignaCartaLiqDAO = asignaCartaLiqDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public ConsolidacionCartaLiqServicio getConsolidacionCartaLiqServicio() {
		return consolidacionCartaLiqServicio;
	}

	public void setConsolidacionCartaLiqServicio(ConsolidacionCartaLiqServicio consolidacionCartaLiqServicio) {
		this.consolidacionCartaLiqServicio = consolidacionCartaLiqServicio;
	}

	public CartaLiquidacionDAO getCartaLiquidacionDAO() {
		return cartaLiquidacionDAO;
	}

	public void setCartaLiquidacionDAO(CartaLiquidacionDAO cartaLiquidacionDAO) {
		this.cartaLiquidacionDAO = cartaLiquidacionDAO;
	}
}