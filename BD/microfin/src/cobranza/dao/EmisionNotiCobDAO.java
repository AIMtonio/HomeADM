package cobranza.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParametrosSisBean;
import soporte.dao.ParametrosSisDAO;
import cobranza.bean.EmisionNotiCobBean;
import cobranza.bean.FormatoNotificaBean;
import credito.bean.AutorizaAvalesBean;
import credito.bean.AutorizaAvalesDetalleBean;
import credito.dao.AutorizaAvalesDAO;

public class EmisionNotiCobDAO extends BaseDAO{
	private final static String salidaPantalla = "S";
	ParametrosSisDAO parametrosSisDAO = null;
	AutorizaAvalesDAO autorizaAvalesDAO = null;

	public EmisionNotiCobDAO(){

	}

	public MensajeTransaccionBean altaEmisionNotificacion(final EmisionNotiCobBean emisionNoti,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		EmisionNotiCobBean bean;
		int aux=0;
		try{
			if(listaBean.size() > 0){
				for(int i=0; i<listaBean.size(); i++){
					/* obtenemos un bean de la lista */
					bean = new EmisionNotiCobBean();
					bean = (EmisionNotiCobBean)listaBean.get(i);

					//Se registra cada credito que se notificara
					mensaje = altaEmision(bean);
					//si se registra con exito  se podra generar el PDF
					if(mensaje.getNumero() == 0){
						//se genera el formato PDF de la notificacion
						mensaje = generarNotificacionesPDF(bean);
						if(mensaje.getNumero() != 0){
							//si no se genero el PDF se hace baja del credito
							bajaEmisionNoti(bean);
							throw new Exception(mensaje.getDescripcion());
						}
					}else{
						throw new Exception(mensaje.getDescripcion());
					}

					//Se da un retardo de 10 segundos
					if(aux == 5){
						try{
							Thread.sleep(10000);
							aux=0;
						}catch(InterruptedException e){
							e.printStackTrace();
						}
					}else{
						aux++;
					}
				}
			}else{
				mensaje.setDescripcion("Lista de Creditos vacia");
				throw new Exception(mensaje.getDescripcion());
			}
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Generacion de Reporte de Notificaciones", e);
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}







		return mensaje;
	}

	public MensajeTransaccionBean altaCreditosEmisionNoti(final EmisionNotiCobBean emisionNoti,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					EmisionNotiCobBean bean;

					if(listaBean.size() > 0){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							bean = new EmisionNotiCobBean();
							bean = (EmisionNotiCobBean)listaBean.get(i);

								//Se registra cada credito que se notificara
								mensajeBean = altaEmision(bean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

						}
					}else{
						mensajeBean.setDescripcion("Lista de Creditos vacia");
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de emision de notificaciones", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public MensajeTransaccionBean altaEmision(final EmisionNotiCobBean emisionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call EMISIONNOTICOBALT(" +
													"?,?,?,?,?," +
													"?,?,?, ?,?,?," +
													"?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(emisionBean.getCreditoID()));
									sentenciaStore.setDate("Par_FechaEmision",OperacionesFechas.conversionStrDate(emisionBean.getFechaSis()));
									sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(emisionBean.getUsuarioID()));
									sentenciaStore.setString("Par_ClaveUsuario",emisionBean.getClaveUsuario());
									sentenciaStore.setInt("Par_SucursalUsuID",Utileria.convierteEntero(emisionBean.getSucursalUsuID()));

									sentenciaStore.setInt("Par_FormatoID",Utileria.convierteEntero(emisionBean.getFormatoID()));
									sentenciaStore.setDate("Par_FechaCita"	,OperacionesFechas.conversionStrDate(emisionBean.getFechaCita()));
									sentenciaStore.setString("Par_HoraCita",emisionBean.getHoraCita());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EmisionNotiCobDAO.altaEmision");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .EmisionNotiCobDAO.altaEmision");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de emision de notificaciones" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List listaEmisionCreditos(int tipoLista,EmisionNotiCobBean emisionBean){
		String query = "call EMISIONNOTICOBLIS(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteEntero(emisionBean.getSucursalID()),
				emisionBean.getEstCredBusq(),
				Utileria.convierteEntero(emisionBean.getEstadoID()),
				Utileria.convierteEntero(emisionBean.getDiasAtrasoIni()),
				Utileria.convierteEntero(emisionBean.getMunicipioID()),

				Utileria.convierteEntero(emisionBean.getDiasAtrasoFin()),
				Utileria.convierteEntero(emisionBean.getLocalidadID()),
				Utileria.convierteEntero(emisionBean.getLimiteRenglones()),
				Utileria.convierteEntero(emisionBean.getColoniaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EmisionNotiCobDAO.listaEmisionCreditos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMISIONNOTICOBLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				EmisionNotiCobBean emisionNotiCobBean = new EmisionNotiCobBean();

				emisionNotiCobBean.setClienteID(resultSet.getString("ClienteID"));
				emisionNotiCobBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				emisionNotiCobBean.setSucursalID(resultSet.getString("SucursalID"));
				emisionNotiCobBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				emisionNotiCobBean.setNombreLocalidad(resultSet.getString("NombreLocalidad"));

				emisionNotiCobBean.setCreditoID(resultSet.getString("CreditoID"));
				emisionNotiCobBean.setProductoCred(resultSet.getString("ProductoCred"));
				emisionNotiCobBean.setSaldoTotalCap(resultSet.getString("SaldoTotalCap"));
				emisionNotiCobBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				emisionNotiCobBean.setEstatusCredito(resultSet.getString("EstatusCredito"));

				emisionNotiCobBean.setFrecuenPagoCap(resultSet.getString("FrecuenPagoCap"));
				emisionNotiCobBean.setEtiquetaEtapa(resultSet.getString("EtiquetaEtapa"));
				emisionNotiCobBean.setFormatoID(resultSet.getString("FormatoID"));
				emisionNotiCobBean.setNombreFormato(resultSet.getString("NombreFormato"));
				emisionNotiCobBean.setEmitirCheck(resultSet.getString("Emitir"));
				emisionNotiCobBean.setFechaCita(resultSet.getString("FechaCita"));

				emisionNotiCobBean.setHoraCita(resultSet.getString("HoraCita"));
				emisionNotiCobBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));

				return emisionNotiCobBean;
			}
		});
		return matches;
	}

	public FormatoNotificaBean consultaFormatoNoti(int tipoConsulta, FormatoNotificaBean emisisonBean) {
		//Query con el Store Procedure
		String query = "call FORMATONOTIFICACOBCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	emisisonBean.getFormatoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AsignaCarteraDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FORMATONOTIFICACOBCON(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FormatoNotificaBean formatoNotiCob = new FormatoNotificaBean();

				formatoNotiCob.setFormatoID(resultSet.getString("FormatoID"));
				formatoNotiCob.setDescripcion(resultSet.getString("Descripcion"));
				formatoNotiCob.setReporte(resultSet.getString("Reporte"));
				formatoNotiCob.setTipo(resultSet.getString("Tipo"));

				return formatoNotiCob;
			}
		});

		return matches.size() > 0 ? (FormatoNotificaBean) matches.get(0) : null;
	}

	//---------------------- Baja de Creditos si no se genero su reporte PDF
	public MensajeTransaccionBean bajaEmisionNoti(final EmisionNotiCobBean emisionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call EMISIONNOTICOBBAJ(" +
										"?,?,?, ?,?,?," +
										"?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(emisionBean.getCreditoID()));
									sentenciaStore.setDate("Par_FechaEmision",OperacionesFechas.conversionStrDate(emisionBean.getFechaSis()));
									sentenciaStore.setInt("Par_FormatoID",Utileria.convierteEntero(emisionBean.getFormatoID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString(1)));
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.STRING_VACIO);
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .EsquemaNotificaDAO.bajaEmisionNoti");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de Emision de notificaciones" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
		return mensaje;
	}

	public MensajeTransaccionBean generarNotificacionesPDF(EmisionNotiCobBean emisionNoti){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			//Se crea nombre de la carpeta donde se alamacenaran las reportes de notificaciones
			String fechaSis = emisionNoti.getFechaSis().trim().replaceAll(" ","").replaceAll("\\-","");
			String nombreCarpeta = fechaSis+"_"+emisionNoti.getClaveUsuario();

			//Se obtiene la Ruta Notificaciones Cobranza de parametros generales donde se almacenaran los reportes de notificaciones
			int tipoConsulta=1;
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean.setEmpresaID(Integer.toString(parametrosAuditoriaBean.getEmpresaID()));
			parametrosSisBean = parametrosSisDAO.consultaPrincipal(parametrosSisBean,tipoConsulta);

			if((parametrosSisBean.getRutaNotifiCobranza()).equals("")){
				mensaje.setDescripcion("No se Defino la Ruta Notificaciones Cobranza");
				throw new Exception(mensaje.getDescripcion());
			}
			//Se crea nombre del directorio con la ruta y el nombre de la carpeta
			String directorio = parametrosSisBean.getRutaNotifiCobranza() +nombreCarpeta+"/";

			//Solo si no existe la carpeta se creara
			boolean exists = (new File(directorio)).exists();

			if (!exists) {
				File aDir = new File(directorio);
				aDir.mkdir();
			}

			int tipoConFor = 1; // consulta datos del formato de notificacion a generar
			//Se creara un reporte de notificacion por cada credito seleccionado

			FormatoNotificaBean formatoNoti = new FormatoNotificaBean();
			formatoNoti.setFormatoID(emisionNoti.getFormatoID());
			formatoNoti = consultaFormatoNoti(tipoConFor,formatoNoti);

			if(formatoNoti == null){
				mensaje.setDescripcion("No existe el Formato de Notificacion");
				throw new Exception(mensaje.getDescripcion());
			}

			if((formatoNoti.getTipo()).equals("C") ){

				String nombreReporte = "cobranza/"+formatoNoti.getReporte();
				ParametrosReporte parametrosReporte = new ParametrosReporte();

				parametrosReporte.agregaParametro("Par_CreditoID",emisionNoti.getCreditoID());
				parametrosReporte.agregaParametro("Par_FormatoID",emisionNoti.getFormatoID());
				parametrosReporte.agregaParametro("Par_FechaSis",emisionNoti.getFechaSis());
				parametrosReporte.agregaParametro("Par_EtiquetaEtapa",emisionNoti.getEtiquetaEtapa());
				parametrosReporte.agregaParametro("Par_NomInstitucion",emisionNoti.getNombreInsti());

				//verificamos que exista el prpt
				boolean existsPRPT = (new File(parametrosAuditoriaBean.getRutaReportes()+nombreReporte)).exists();
				if (!existsPRPT) {
					mensaje.setDescripcion("No existe el Formato de Notificación: "+formatoNoti.getDescripcion());
					throw new Exception(mensaje.getDescripcion());
				}

					//Se crea un reporte PDF de notificacion para el cliente
				ByteArrayOutputStream htmlStringPDF = null;
				htmlStringPDF = Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

				if(htmlStringPDF == null){
					mensaje.setDescripcion("Fallo en la Generacion del Reporte de Notificacion del Credito: "+emisionNoti.getCreditoID());
					throw new Exception(mensaje.getDescripcion());
				}

				byte[] bytes = htmlStringPDF.toByteArray();
				String nombrePDF = emisionNoti.getCreditoID()+"-"+formatoNoti.getDescripcion()+"-"+emisionNoti.getFechaSis()+".pdf";
				nombrePDF = nombrePDF.trim().replaceAll(" ","-");

				if(bytes.length > 0){
					//Se ecribe el reporte PDF en el directorio establecido
					File filespring = new File(directorio+nombrePDF);
			      	FileUtils.writeByteArrayToFile(filespring, bytes);
				}else{
					mensaje.setDescripcion("Fallo en la Generacion del Reporte de Notificacion del Credito: "+emisionNoti.getCreditoID());
					throw new Exception(mensaje.getDescripcion());
				}
			}else{
				if((formatoNoti.getTipo()).equals("A") ){
					List listaAvalesBean = null;
					AutorizaAvalesBean avalesBean = new AutorizaAvalesBean();
					int tipoLisAvales=1;

					//consultamos la lista de los avales del credito y generamor ua notificacion por cada aval

					int soliCredID = Utileria.convierteEntero(emisionNoti.getSolicitudCreditoID());
					if(soliCredID > 0){

						avalesBean.setSolicitudCreditoID(emisionNoti.getSolicitudCreditoID());
						listaAvalesBean =  autorizaAvalesDAO.listaAlfanumerica(avalesBean, tipoLisAvales);
						if(listaAvalesBean == null){
							bajaEmisionNoti(emisionNoti);
							mensaje.setDescripcion("Fallo en la Lista de Avales del Credito: "+emisionNoti.getCreditoID());
							throw new Exception(mensaje.getDescripcion());
						}

						for(int x=0; x<listaAvalesBean.size(); x++){
							AutorizaAvalesDetalleBean aval = (AutorizaAvalesDetalleBean)listaAvalesBean.get(x);

							String nombreReporte = "cobranza/"+formatoNoti.getReporte();
							ParametrosReporte parametrosReporte = new ParametrosReporte();

							parametrosReporte.agregaParametro("Par_CreditoID",emisionNoti.getCreditoID());
							parametrosReporte.agregaParametro("Par_FormatoID",emisionNoti.getFormatoID());
							parametrosReporte.agregaParametro("Par_FechaSis",emisionNoti.getFechaSis());
							parametrosReporte.agregaParametro("Par_EtiquetaEtapa",emisionNoti.getEtiquetaEtapa());
							parametrosReporte.agregaParametro("Par_NomInstitucion",emisionNoti.getNombreInsti());

							parametrosReporte.agregaParametro("Par_NombreAval",aval.getNombre());
							parametrosReporte.agregaParametro("Par_AvalClienteID",aval.getClienteID());
							parametrosReporte.agregaParametro("Par_AvalID",aval.getAvalID());
							parametrosReporte.agregaParametro("Par_ProspectoID",aval.getProspectoID());

							//verificamos que exista el prpt
							boolean existsPRPT = (new File(parametrosAuditoriaBean.getRutaReportes()+nombreReporte)).exists();
							if (!existsPRPT) {
								mensaje.setDescripcion("No existe el Formato de Notificación: "+formatoNoti.getDescripcion());
								throw new Exception(mensaje.getDescripcion());
							}

							//Se crea un reporte PDF de notificacion para cada aval del credito
							ByteArrayOutputStream htmlStringPDF = null;
							htmlStringPDF = Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

							if(htmlStringPDF == null){
								mensaje.setDescripcion("Fallo en la Generacion del Reporte de Notificacion del Credito para Avales: "+emisionNoti.getCreditoID());
								throw new Exception(mensaje.getDescripcion());
							}

							byte[] bytes = htmlStringPDF.toByteArray();
							String nombrePDF = emisionNoti.getCreditoID()+"-"+formatoNoti.getDescripcion()+"-"+x+"-"+emisionNoti.getFechaSis()+".pdf";
							nombrePDF = nombrePDF.trim().replaceAll(" ","-");

							if(bytes.length > 0){
								//Se ecribe el reporte PDF en el directorio establecido
								File filespring = new File(directorio+nombrePDF);
						      	FileUtils.writeByteArrayToFile(filespring, bytes);
							}else{
								mensaje.setDescripcion("Fallo en la Generacion del Reporte de Notificacion del Credito: "+emisionNoti.getCreditoID());
								throw new Exception(mensaje.getDescripcion());
							}
						}
					}
				}
			}
	      	mensaje.setNumero(0);
	      	mensaje.setDescripcion("Emision de Notificaciones Realizada con Exito");
	      	mensaje.setNombreControl("sucursalID");

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Generacion de Reporte de Notificaciones", e);
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}


	// Metodos getter y setter
	public ParametrosSisDAO getParametrosSisDAO() {
		return parametrosSisDAO;
	}

	public void setParametrosSisDAO(ParametrosSisDAO parametrosSisDAO) {
		this.parametrosSisDAO = parametrosSisDAO;
	}

	public AutorizaAvalesDAO getAutorizaAvalesDAO() {
		return autorizaAvalesDAO;
	}

	public void setAutorizaAvalesDAO(AutorizaAvalesDAO autorizaAvalesDAO) {
		this.autorizaAvalesDAO = autorizaAvalesDAO;
	}


}
