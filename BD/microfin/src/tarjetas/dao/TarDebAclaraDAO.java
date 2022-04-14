package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarDebAclaraBean;
import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.servicio.TarDebArchAclaServicio;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebAclaraDAO  extends BaseDAO{
	public TarDebAclaraDAO() {
		super();
	}
	TarDebArchAclaServicio tarDebArchAclaServicio = null;

	public MensajeTransaccionBean altaAclaracion(int tipoTransaccion,final TarDebAclaraBean tarDebAclaraBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					 tarDebAclaraBean.setTarjetaDebID(tarDebAclaraBean.getTarjetaDebID().replace(",", ""));
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TARDEBACLARACIONALT(?,?,?,?,?," +
											"?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,		?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_TipoReporte",Utileria.convierteEntero(tarDebAclaraBean.getTipoReporte()));
									sentenciaStore.setString("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
									sentenciaStore.setString("Par_TipoTarjeta",tarDebAclaraBean.getTipoTarjeta());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(tarDebAclaraBean.getInstitucionID()));
									sentenciaStore.setInt("Par_OperacionID",Utileria.convierteEntero(tarDebAclaraBean.getOperacionID()));
									sentenciaStore.setString("Par_TiendaComercio",tarDebAclaraBean.getTienda());

									sentenciaStore.setString("Par_CajeroID",tarDebAclaraBean.getCajeroID());
									sentenciaStore.setString("Par_MontoOperacion",tarDebAclaraBean.getMontoOperacion());
									sentenciaStore.setString("Par_FechaOperacion",tarDebAclaraBean.getFechaOperacion());
									sentenciaStore.setInt("Par_NumTransaccion",Utileria.convierteEntero(tarDebAclaraBean.getTransaccionID()));
									sentenciaStore.setString("Par_DetalleReporte",tarDebAclaraBean.getDetalleReporte());

									sentenciaStore.setString("Par_NumAutorizacion",tarDebAclaraBean.getNoAutorizacion());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarDebAclaraDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosAclara = callableStatement.getResultSet();

										resultadosAclara.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosAclara.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosAclara.getString(2));
										mensajeTransaccion.setNombreControl(resultadosAclara.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosAclara.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}// public
							});// CallableStatementCallback
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de la aclaracion", e);
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
						}// catch
						return mensajeBean;
					} // public Object doInTransaction
		}); //men
		return mensaje;
	}

	public TarDebAclaraBean consulta(final int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
		String query = "call TARDEBACLARACIONCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				tarDebAclaraBean.getReporteID(),
				tarDebAclaraBean.getTipoTarjeta(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebAclaraDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebAclaraBean reporteAclaracionBean = new TarDebAclaraBean();
				reporteAclaracionBean.setReporteID(resultSet.getString("ReporteID"));
				reporteAclaracionBean.setTipoReporte(resultSet.getString("TipoAclaraID"));
				reporteAclaracionBean.setOperacionID(resultSet.getString("OpeAclaraID"));
				reporteAclaracionBean.setEstatus(resultSet.getString("Estatus"));
				reporteAclaracionBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));

				reporteAclaracionBean.setTipoTarjetaID(resultSet.getString("TipoTarjetaDebID"));
				reporteAclaracionBean.setTipoTarjeta(resultSet.getString("Descripcion"));
				reporteAclaracionBean.setClienteID(resultSet.getString("ClienteID"));
				reporteAclaracionBean.setNombre(resultSet.getString("NombreCompleto"));
				reporteAclaracionBean.setNumCuenta(resultSet.getString("CuentaAhoID"));

				reporteAclaracionBean.setTipoCuenta(resultSet.getString("Etiqueta"));
				reporteAclaracionBean.setCorporativoID(resultSet.getString("ClienteCorporativo"));
				reporteAclaracionBean.setNombreCorp(resultSet.getString("RazonSocial"));
				reporteAclaracionBean.setInstitucionID(resultSet.getString("InstitucionID"));
				reporteAclaracionBean.setNombreInstitucion(resultSet.getString("Nombre"));

				reporteAclaracionBean.setTienda(resultSet.getString("Comercio"));
				reporteAclaracionBean.setCajeroID(resultSet.getString("NoCajero"));
				reporteAclaracionBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				reporteAclaracionBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
				reporteAclaracionBean.setTransaccionID(resultSet.getString("TransaccionRep"));

				reporteAclaracionBean.setDetalleReporte(resultSet.getString("DetalleReporte"));
				reporteAclaracionBean.setNoAutorizacion(resultSet.getString("NoAutorizacion"));
				return reporteAclaracionBean;
			}
		});
		return matches.size() > 0 ? (TarDebAclaraBean) matches.get(0) : null;
	}

	public TarDebAclaraBean resultado(final int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
		String query = "call TARDEBACLARACIONCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				tarDebAclaraBean.getReporteID(),
				tarDebAclaraBean.getTipoTarjeta(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebAclaraDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebAclaraBean reporteAclaracionBean = new TarDebAclaraBean();
				reporteAclaracionBean.setReporteID(resultSet.getString("ReporteID"));
				reporteAclaracionBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				reporteAclaracionBean.setEstatus(resultSet.getString("Estatus"));
				reporteAclaracionBean.setClienteID(resultSet.getString("ClienteID"));
				reporteAclaracionBean.setNombre(resultSet.getString("NombreCompleto"));

				reporteAclaracionBean.setNumCuenta(resultSet.getString("CuentaAhoID"));
				reporteAclaracionBean.setTipoCuenta(resultSet.getString("Etiqueta"));
				reporteAclaracionBean.setCorporativoID(resultSet.getString("ClienteCorporativo"));
				reporteAclaracionBean.setNombreCorp(resultSet.getString("RazonSocial"));
				reporteAclaracionBean.setDescMovimiento(resultSet.getString("Descripcion"));
				reporteAclaracionBean.setDetalleReporte(resultSet.getString("DetalleReporte"));
				reporteAclaracionBean.setDetalleResolucion(resultSet.getString("DetalleResolucion"));
				return reporteAclaracionBean;
			}
		});
		return matches.size() > 0 ? (TarDebAclaraBean) matches.get(0) : null;
	}
	//Consulta de parametros de maximo de dias de aclaracion
	public TarDebAclaraBean consultaParametros(final int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
		String query = "call TARDEBACLARACIONCON(?,?,?,?,?, ?,?,?,?,?);";

		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebAclaraDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebAclaraBean paramAclaracion = new TarDebAclaraBean();
				paramAclaracion.setDiasAclaracion(resultSet.getString(1));
				return paramAclaracion;
			}
		});
		return matches.size() > 0 ? (TarDebAclaraBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean actualizacion(final TarDebAclaraBean tarDebAclaraBean, final String lisFolioID,
			final String lisTipoArchivo, final String lisRuta, final String lisNombreArchivo ) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				//MensajeTransaccionBean mensajeBeanSalida = new MensajeTransaccionBean();
				try {
					ArrayList listaArchAdjuntos= (ArrayList) creaListaArchivos(tarDebAclaraBean, lisFolioID, lisTipoArchivo, lisRuta, lisNombreArchivo);
					TarDebArchAclaBean tarDebArchAcla= new TarDebArchAclaBean();
					tarDebArchAcla.setReporteID(tarDebAclaraBean.getReporteID());
					mensajeBean = tarDebArchAclaServicio.altaArchivos(tarDebArchAcla, listaArchAdjuntos);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean = actualizaAclaracion(tarDebAclaraBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada: "+ mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aclaracion de archivos ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	private List creaListaArchivos(TarDebAclaraBean tarDebAclaraBean, String lisFolioID, String lisTipoArchivo,String lisRuta, String lisNombreArchivo ){
		StringTokenizer tokensFolio = new StringTokenizer(lisFolioID, ",");
		StringTokenizer tokensTipoArchivo= new StringTokenizer(lisTipoArchivo, ",");
		StringTokenizer tokensRuta = new StringTokenizer(lisRuta, ",");
		StringTokenizer tokensNombres = new StringTokenizer(lisNombreArchivo, ",");

		ArrayList listaArchi= new ArrayList();
		TarDebArchAclaBean tarDebArchAclaBean;

		String limFolios[] = new String[tokensFolio.countTokens()];
		String limTipoArchivos[] = new String[tokensTipoArchivo.countTokens()];
		String limRutas[] = new String[tokensRuta.countTokens()];
		String limNombres[] = new String[tokensNombres.countTokens()];

		int i=0;
		while(tokensFolio.hasMoreTokens()){
			limFolios[i] = String.valueOf(tokensFolio.nextToken());
			i++;
		}
		i=0;
		while(tokensTipoArchivo.hasMoreTokens()){
			limTipoArchivos[i] = String.valueOf(tokensTipoArchivo.nextToken());
			i++;
		}
		i=0;
		while(tokensRuta.hasMoreTokens()){
			limRutas[i] = String.valueOf(tokensRuta.nextToken());
			i++;
		}
		i=0;
		while(tokensNombres.hasMoreTokens()){
			limNombres[i] = String.valueOf(tokensNombres.nextToken());
			i++;
		}
		for(int contador=0; contador < limFolios.length; contador++){
			tarDebArchAclaBean = new TarDebArchAclaBean();
			tarDebArchAclaBean.setReporteID(tarDebAclaraBean.getReporteID());
			tarDebArchAclaBean.setFolioID(String.valueOf(limFolios[contador]));
			tarDebArchAclaBean.setTipoArchivo(String.valueOf(limTipoArchivos[contador]));
			tarDebArchAclaBean.setRuta(String.valueOf(limRutas[contador]));
			tarDebArchAclaBean.setNombreArchivo(String.valueOf(limNombres[contador]));

			listaArchi.add(tarDebArchAclaBean);
		}
		return listaArchi;
	}

	public MensajeTransaccionBean actualizaAclaracion(final TarDebAclaraBean tarDebAclaraBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					tarDebAclaraBean.setTarjetaDebID(tarDebAclaraBean.getTarjetaDebID().replace(",", ""));
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBACLARACIONACT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoReporte",Utileria.convierteEntero(tarDebAclaraBean.getTipoReporte()));
								sentenciaStore.setInt("Par_NoReporte",Utileria.convierteEntero(tarDebAclaraBean.getReporteID()));
								sentenciaStore.setString("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
								sentenciaStore.setString("Par_TipoTarjeta",tarDebAclaraBean.getTipoTarjeta());
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(tarDebAclaraBean.getInstitucionID()));

								sentenciaStore.setInt("Par_OperacionID",Utileria.convierteEntero(tarDebAclaraBean.getOperacionID()));
								sentenciaStore.setString("Par_TiendaComercio",tarDebAclaraBean.getTienda());
								sentenciaStore.setString("Par_CajeroID",tarDebAclaraBean.getCajeroID());
								sentenciaStore.setString("Par_MontoOperacion",tarDebAclaraBean.getMontoOperacion());
								sentenciaStore.setString("Par_FechaOperacion",tarDebAclaraBean.getFechaOperacion());

								sentenciaStore.setLong("Par_NumTransaccion",Utileria.convierteLong(tarDebAclaraBean.getTransaccionID()));
								sentenciaStore.setString("Par_DetalleReporte",tarDebAclaraBean.getDetalleReporte());
								sentenciaStore.setString("Par_NumAutorizacion",tarDebAclaraBean.getNoAutorizacion());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion("Fallo. Error al actualizar la aclaracion.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. Error al actualizar la aclaracion.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de la aclaracion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean actualizaResultaAclaracion(final TarDebAclaraBean tarDebAclaraBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					tarDebAclaraBean.setTarjetaDebID(tarDebAclaraBean.getTarjetaDebID().replace(",", ""));
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBACLARARESACT(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ReporteID",tarDebAclaraBean.getReporteID());
								sentenciaStore.setString("Par_TarjetaDebID",tarDebAclaraBean.getTarjetaDebID());
								sentenciaStore.setString("Par_UsuarioResolucion",tarDebAclaraBean.getUsuarioID());
								sentenciaStore.setString("Par_EstatusResult",tarDebAclaraBean.getEstatusResult());
								sentenciaStore.setString("Par_DetalleResolucion",tarDebAclaraBean.getDetalleResolucion());


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion("Fallo. Error al actualizar la aclaracion.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. Error al actualizar la aclaracion.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de la aclaracion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Lista numero de Reportes y las Tarjetas de las Aclaraciones */
	public List listaAclara(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
		List listaAclara=null;
		try{
		String query = "call TARDEBACLARACIONLIS(?,?,?,?,?,  ?,?,? ,  ?,?,?,?);";
		Object[] parametros = {
								tarDebAclaraBean.getReporteID(),
								Constantes.STRING_VACIO,
								tarDebAclaraBean.getTipoTarjeta(),
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaAclara",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebAclaraBean tarjetaAclaracion = new TarDebAclaraBean();
				tarjetaAclaracion.setReporteID(resultSet.getString(1));
				tarjetaAclaracion.setTarjetaDebID(resultSet.getString(2));

				return tarjetaAclaracion;
			}
		});

		listaAclara= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de reporte de aclaraciones", e);
		}
		return listaAclara;
	}

	/* Lista numero de Reportes y las Tarjetas de las Aclaraciones */
	public List listaAclaraCred(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
		List listaAclara=null;
		try{
		String query = "call TARDEBACLARACIONLIS(?,?,?,?,?,  ?,?,? ,  ?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								tarDebAclaraBean.getTarjetaDebID(),
								Constantes.STRING_VACIO,
								tarDebAclaraBean.getFechaOperacion(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaAclara",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebAclaraBean tarjetaAclaracion = new TarDebAclaraBean();
				tarjetaAclaracion.setNumeroTransaccion(resultSet.getString(1));
				tarjetaAclaracion.setDescMovimiento(resultSet.getString(2));

				return tarjetaAclaracion;
			}
		});

		listaAclara= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de reporte de aclaraciones", e);
		}
		return listaAclara;
	}

	/* Lista Transacciones */
	public List listaTransaccion(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
		List listaTransaccion=null;
		try{
		String query = "call TARDEBACLARACIONLIS(?,?,?,?,?, ?,?,?,?,?, ?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								tarDebAclaraBean.getTarjetaDebID(),
								Constantes.STRING_VACIO,
								tarDebAclaraBean.getFechaOperacion(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaTransaccion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarDebAclaraBean tarjetaTransaccion = new TarDebAclaraBean();
				tarjetaTransaccion.setNumeroTransaccion(resultSet.getString(1));
				tarjetaTransaccion.setDescMovimiento(resultSet.getString(2));

				return tarjetaTransaccion;
			}
		});
		listaTransaccion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de transacciones", e);
		}
		return listaTransaccion;
	}


	public TarDebAclaraBean consultaCredito(final int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
		String query = "call TARDEBACLARACIONCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				tarDebAclaraBean.getReporteID(),
				tarDebAclaraBean.getTipoTarjeta(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebAclaraDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebAclaraBean reporteAclaracionBean = new TarDebAclaraBean();
				reporteAclaracionBean.setTipoReporte(resultSet.getString("TipoAclaraID"));
				reporteAclaracionBean.setReporteID(resultSet.getString("ReporteID"));
				reporteAclaracionBean.setEstatus(resultSet.getString("Estatus"));
				reporteAclaracionBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
				reporteAclaracionBean.setTipoTarjetaID(resultSet.getString("TipoTarjetaCredID"));

				reporteAclaracionBean.setTipoTarjeta(resultSet.getString("Descripcion"));
				reporteAclaracionBean.setClienteID(resultSet.getString("ClienteID"));
				reporteAclaracionBean.setNombre(resultSet.getString("NombreCompleto"));
				reporteAclaracionBean.setLineaCredito(resultSet.getString("LineaTarCredID"));
				reporteAclaracionBean.setCorporativoID(resultSet.getString("ClienteCorporativo"));

				reporteAclaracionBean.setNombreCorp(resultSet.getString("RazonSocial"));
				reporteAclaracionBean.setInstitucionID(resultSet.getString("InstitucionID"));
				reporteAclaracionBean.setNombreInstitucion(resultSet.getString("Nombre"));
				reporteAclaracionBean.setOperacionID(resultSet.getString("OpeAclaraID"));
				reporteAclaracionBean.setTienda(resultSet.getString("Comercio"));

				reporteAclaracionBean.setCajeroID(resultSet.getString("NoCajero"));
				reporteAclaracionBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				reporteAclaracionBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
				reporteAclaracionBean.setTransaccionID(resultSet.getString("TransaccionRep"));
				reporteAclaracionBean.setDetalleReporte(resultSet.getString("DetalleReporte"));

				reporteAclaracionBean.setNoAutorizacion(resultSet.getString("NoAutorizacion"));
				reporteAclaracionBean.setNombreProducto(resultSet.getString("NombreProducto"));
				reporteAclaracionBean.setProductoID(resultSet.getString("ProducCreditoID"));

				return reporteAclaracionBean;
			}
		});
		return matches.size() > 0 ? (TarDebAclaraBean) matches.get(0) : null;
	}



		public List listaResultadoAclara(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
			List listaAclara=null;
			try{
			String query = "call TARDEBACLARARESLIS(?,?,  ?,?,? ,?,?,?,?);";
			Object[] parametros = {
									tarDebAclaraBean.getReporteID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"listaAclara",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARARESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarDebAclaraBean tarjetaAclaracion = new TarDebAclaraBean();
					tarjetaAclaracion.setReporteID(resultSet.getString(1));
					tarjetaAclaracion.setTarjetaDebID(resultSet.getString(2));

					return tarjetaAclaracion;
				}
			});

			listaAclara= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de reporte de aclaraciones", e);
			}
			return listaAclara;
		}

		public List listaPuesto(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
			List listaPrincipal=null;
			try{
				String query = "call PUESTOSLIS(?,?,?,   ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"listaPuesto.listaPuesto",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUESTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarDebAclaraBean tarDebAclaraBean = new TarDebAclaraBean();
					tarDebAclaraBean.setClaveID(resultSet.getString(1));
					tarDebAclaraBean.setDescripcion(resultSet.getString(2));
					return tarDebAclaraBean;
				}
			});
			listaPrincipal= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
			}
			return listaPrincipal;
		}

		public List listaResultCreAclara(TarDebAclaraBean tarDebAclaraBean, int tipoLista) {
			List listaAclara=null;
			try{
			String query = "call TARDEBACLARARESLIS(?,?,  ?,?,? ,?,?,?,?);";
			Object[] parametros = {
									tarDebAclaraBean.getReporteID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"listaAclara",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARARESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarDebAclaraBean tarjetaAclaracion = new TarDebAclaraBean();
					tarjetaAclaracion.setReporteID(resultSet.getString(1));
					tarjetaAclaracion.setTarjetaDebID(resultSet.getString(2));

					return tarjetaAclaracion;
				}
			});

			listaAclara= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de reporte de aclaraciones", e);
			}
			return listaAclara;
		}

		public TarDebAclaraBean resultadoCre(final int tipoConsulta, TarDebAclaraBean tarDebAclaraBean){
			String query = "call TARDEBACLARACIONCON(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					tarDebAclaraBean.getReporteID(),
					tarDebAclaraBean.getTipoTarjeta(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarDebAclaraDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBACLARACIONCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarDebAclaraBean reporteAclaracionBean = new TarDebAclaraBean();
					reporteAclaracionBean.setReporteID(resultSet.getString("ReporteID"));
					reporteAclaracionBean.setTarjetaDebID(resultSet.getString("TarjetaDebID"));
					reporteAclaracionBean.setEstatus(resultSet.getString("Estatus"));
					reporteAclaracionBean.setClienteID(resultSet.getString("ClienteID"));
					reporteAclaracionBean.setNombre(resultSet.getString("NombreCompleto"));
					reporteAclaracionBean.setCorporativoID(resultSet.getString("ClienteCorporativo"));
					reporteAclaracionBean.setNombreCorp(resultSet.getString("RazonSocial"));
					reporteAclaracionBean.setDescMovimiento(resultSet.getString("Descripcion"));
					reporteAclaracionBean.setDetalleReporte(resultSet.getString("DetalleReporte"));
					reporteAclaracionBean.setDetalleResolucion(resultSet.getString("DetalleResolucion"));
					reporteAclaracionBean.setNombreProducto(resultSet.getString("NombreProducto"));
					reporteAclaracionBean.setProductoID(resultSet.getString("ProducCreditoID"));
					return reporteAclaracionBean;
				}
			});
			return matches.size() > 0 ? (TarDebAclaraBean) matches.get(0) : null;
		}

	public TarDebArchAclaServicio getTarDebArchAclaServicio() {
		return tarDebArchAclaServicio;
	}

	public void setTarDebArchAclaServicio(
			TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}
}
