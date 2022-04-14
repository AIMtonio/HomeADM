package fira.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import fira.bean.GarantiaAgroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class GarantiasAgroDAO  extends BaseDAO{
	public GarantiasAgroDAO(){
		super();
	}

	public final static String FECHA_VACIA = "1900-01-01";

	public MensajeTransaccionBean altaGarantia(final GarantiaAgroBean garantiaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call GARANTIASAGROALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?,  ?," +
									"?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_GarantiaID",Utileria.convierteEntero(garantiaBean.getGarantiaID()));
							sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(garantiaBean.getProspectoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(garantiaBean.getClienteID()));
							sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(garantiaBean.getAvalID()));
							sentenciaStore.setInt("Par_GaranteID",Utileria.convierteEntero(garantiaBean.getGaranteID()));

							sentenciaStore.setString("Par_GaranteNombre",garantiaBean.getGaranteNombre());
							sentenciaStore.setInt("Par_TipoGarantiaID",Utileria.convierteEntero(garantiaBean.getTipoGarantiaID()));
							sentenciaStore.setInt("Par_ClasifGarantiaID",Utileria.convierteEntero(garantiaBean.getClasifGarantiaID()));
							sentenciaStore.setDouble("Par_ValorComercial",Utileria.convierteDoble(garantiaBean.getValorComercial()));
							sentenciaStore.setString("Par_Observaciones",garantiaBean.getObservaciones().trim());

							sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(garantiaBean.getEstadoID()));
							sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(garantiaBean.getMunicipioID()));
							sentenciaStore.setString("Par_Calle",garantiaBean.getCalle());
							sentenciaStore.setString("Par_Numero",garantiaBean.getNumero());
							sentenciaStore.setString("Par_NumeroInt",garantiaBean.getNumeroInt());

							sentenciaStore.setString("Par_Lote",garantiaBean.getLote());
							sentenciaStore.setString("Par_Manzana",garantiaBean.getManzana());
							sentenciaStore.setString("Par_Colonia",garantiaBean.getColonia());
							sentenciaStore.setString("Par_CodigoPostal",garantiaBean.getCodigoPostal());
							sentenciaStore.setDouble("Par_M2Construccion",Utileria.convierteDoble(garantiaBean.getM2Construccion()));

							sentenciaStore.setDouble("Par_M2Terreno",Utileria.convierteDoble(garantiaBean.getM2Terreno()));
							sentenciaStore.setString("Par_Asegurado",garantiaBean.getAsegurado());
							sentenciaStore.setDate("Par_VencimientoPoliza",OperacionesFechas.conversionStrDate(garantiaBean.getVencimientoPoliza()));
							sentenciaStore.setDate("Par_FechaValuacion",OperacionesFechas.conversionStrDate(garantiaBean.getFechaValuacion()));
							sentenciaStore.setString("Par_NumAvaluo",garantiaBean.getNumAvaluo());

							sentenciaStore.setString("Par_NombreValuador",garantiaBean.getNombreValuador());
							sentenciaStore.setString("Par_Verificada",garantiaBean.getVerificada());
							sentenciaStore.setDate("Par_FechaVerificacion",OperacionesFechas.conversionStrDate(garantiaBean.getFechaVerificacion()));
							sentenciaStore.setString("Par_TipoGravemen",garantiaBean.getTipoGravemen());
							sentenciaStore.setString("Par_TipoInsCaptacion",garantiaBean.getTipoInsCaptacion());

							sentenciaStore.setInt("Par_InsCaptacionID",Utileria.convierteEntero(garantiaBean.getInsCaptacionID()));
							sentenciaStore.setDouble("Par_MontoAsignado",Utileria.convierteDoble(garantiaBean.getMontoAsignado()));
							sentenciaStore.setString("Par_Estatus",garantiaBean.getEstatus());
							sentenciaStore.setString("Par_NoIdentificacion",garantiaBean.getNumIdentificacion());
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(garantiaBean.getTipoDocumentoID()));

							sentenciaStore.setString("Par_Asegurador",garantiaBean.getAsegurador() );
							sentenciaStore.setString("Par_NombreAutoridad",garantiaBean.getNombreAutoridad() );
							sentenciaStore.setString("Par_CargoAutoridad",garantiaBean.getCargoAutoridad() );
							sentenciaStore.setDate("Par_FechaCompFactura",OperacionesFechas.conversionStrDate(garantiaBean.getFechaCompFactura()) );
							sentenciaStore.setDate("Par_FechaGrevemen",OperacionesFechas.conversionStrDate(garantiaBean.getFechagravemen()));

							sentenciaStore.setString("Par_FolioRegistro",garantiaBean.getFolioRegistro() );
							sentenciaStore.setString("Par_MontoGravemen",garantiaBean.getMontoGravemen());
							sentenciaStore.setString("Par_NombBenefiGravem",garantiaBean.getNombBenefiGrav());
							sentenciaStore.setInt("Par_NotarioID",Utileria.convierteEntero(garantiaBean.getNotarioID()));
							sentenciaStore.setLong("Par_NumPoliza",Utileria.convierteLong(garantiaBean.getNumPoliza()));

							sentenciaStore.setString("Par_ReferenFactura",garantiaBean.getReferenciafact() );
							sentenciaStore.setString("Par_RFCEmisor",garantiaBean.getRfcEmisor() );
							sentenciaStore.setString("Par_SerieFactura",garantiaBean.getSerieFactura() );
							sentenciaStore.setString("Par_ValorFactura",garantiaBean.getValorFactura() );
							sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(garantiaBean.getFechaRegistro()));

							sentenciaStore.setString("Par_CalleGarante",garantiaBean.getCalleGarante());
							sentenciaStore.setString("Par_NumIntGarante",garantiaBean.getNumIntGarante() );
							sentenciaStore.setString("Par_NumExtGarante",garantiaBean.getNumExtGarante() );
							sentenciaStore.setString("Par_ColoniaGarante",garantiaBean.getColoniaGarante() );
							sentenciaStore.setString("Par_CodPostalGarante",garantiaBean.getCodPostalGarante());

							sentenciaStore.setInt("Par_EstadoIDGarante",Utileria.convierteEntero(garantiaBean.getEstadoGarante()));
							sentenciaStore.setInt("Par_MunicipioGarante",Utileria.convierteEntero(garantiaBean.getMunicipioGarante()));

							sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(garantiaBean.getLocalidadIDGarante()));
							sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(garantiaBean.getColoniaID()));
							sentenciaStore.setDouble("Par_MontoAvaluo",Utileria.convierteDoble(garantiaBean.getMontoAvaluo()));
							sentenciaStore.setDouble("Par_Proporcion",Utileria.convierteDoble(garantiaBean.getProporcion()));
							sentenciaStore.setString("Par_Usufructuaria", garantiaBean.getUsufructuaria());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.registerOutParameter("Var_FolioSalida", Types.CHAR);

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de garantia", e);
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

	// ::::::  A C T U A L I Z A C I O N :::::::::::::

	public MensajeTransaccionBean actualizaGarantia(final GarantiaAgroBean garantiaBean) {
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
									String query = "call GARANTIASAGROACT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?,	?," +
											"?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_GarantiaID",Utileria.convierteEntero(garantiaBean.getGarantiaID()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(garantiaBean.getProspectoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(garantiaBean.getClienteID()));
									sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(garantiaBean.getAvalID()));
									sentenciaStore.setInt("Par_GaranteID",Utileria.convierteEntero(garantiaBean.getGaranteID()));

									sentenciaStore.setString("Par_GaranteNombre",garantiaBean.getGaranteNombre());
									sentenciaStore.setInt("Par_TipoGarantiaID",Utileria.convierteEntero(garantiaBean.getTipoGarantiaID()));
									sentenciaStore.setInt("Par_ClasifGarantiaID",Utileria.convierteEntero(garantiaBean.getClasifGarantiaID()));
									sentenciaStore.setDouble("Par_ValorComercial",Utileria.convierteDoble(garantiaBean.getValorComercial()));
									sentenciaStore.setString("Par_Observaciones",garantiaBean.getObservaciones().trim());

									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(garantiaBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(garantiaBean.getMunicipioID()));
									sentenciaStore.setString("Par_Calle",garantiaBean.getCalle());
									sentenciaStore.setString("Par_Numero",garantiaBean.getNumero());
									sentenciaStore.setString("Par_NumeroInt",garantiaBean.getNumeroInt());

									sentenciaStore.setString("Par_Lote",garantiaBean.getLote());
									sentenciaStore.setString("Par_Manzana",garantiaBean.getManzana());
									sentenciaStore.setString("Par_Colonia",garantiaBean.getColonia());
									sentenciaStore.setString("Par_CodigoPostal",garantiaBean.getCodigoPostal());
									sentenciaStore.setDouble("Par_M2Construccion",Utileria.convierteDoble(garantiaBean.getM2Construccion()));

									sentenciaStore.setDouble("Par_M2Terreno",Utileria.convierteDoble(garantiaBean.getM2Terreno()));
									sentenciaStore.setString("Par_Asegurado",garantiaBean.getAsegurado());
									sentenciaStore.setDate("Par_VencimientoPoliza",OperacionesFechas.conversionStrDate(garantiaBean.getVencimientoPoliza()));
									sentenciaStore.setDate("Par_FechaValuacion",OperacionesFechas.conversionStrDate(garantiaBean.getFechaValuacion()));
									sentenciaStore.setString("Par_NumAvaluo",garantiaBean.getNumAvaluo());

									sentenciaStore.setString("Par_NombreValuador",garantiaBean.getNombreValuador());
									sentenciaStore.setString("Par_Verificada",garantiaBean.getVerificada());
									sentenciaStore.setDate("Par_FechaVerificacion",OperacionesFechas.conversionStrDate(garantiaBean.getFechaVerificacion()));
									sentenciaStore.setString("Par_TipoGravemen",garantiaBean.getTipoGravemen());
									sentenciaStore.setString("Par_TipoInsCaptacion",garantiaBean.getTipoInsCaptacion());

									sentenciaStore.setInt("Par_InsCaptacionID",Utileria.convierteEntero(garantiaBean.getInsCaptacionID()));
									sentenciaStore.setDouble("Par_MontoAsignado",Utileria.convierteDoble(garantiaBean.getMontoAsignado()));
									sentenciaStore.setString("Par_Estatus",garantiaBean.getEstatus());
									sentenciaStore.setString("Par_NoIdentificacion",garantiaBean.getNumIdentificacion());
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(garantiaBean.getTipoDocumentoID()));

									sentenciaStore.setString("Par_Asegurador",garantiaBean.getAsegurador() );
									sentenciaStore.setString("Par_NombreAutoridad",garantiaBean.getNombreAutoridad() );
									sentenciaStore.setString("Par_CargoAutoridad",garantiaBean.getCargoAutoridad() );
									sentenciaStore.setDate("Par_FechaCompFactura",OperacionesFechas.conversionStrDate(garantiaBean.getFechaCompFactura()) );
									sentenciaStore.setDate("Par_FechaGrevemen",OperacionesFechas.conversionStrDate(garantiaBean.getFechagravemen()));

									sentenciaStore.setString("Par_FolioRegistro",garantiaBean.getFolioRegistro() );
								    sentenciaStore.setString("Par_MontoGravemen",garantiaBean.getMontoGravemen());
								 	sentenciaStore.setString("Par_NombBenefiGravem",garantiaBean.getNombBenefiGrav());
								    sentenciaStore.setInt("Par_NotarioID",Utileria.convierteEntero(garantiaBean.getNotarioID()));
								    sentenciaStore.setLong("Par_NumPoliza",Utileria.convierteLong(garantiaBean.getNumPoliza()));

									sentenciaStore.setString("Par_ReferenFactura",garantiaBean.getReferenciafact() );
									sentenciaStore.setString("Par_RFCEmisor",garantiaBean.getRfcEmisor() );
									sentenciaStore.setString("Par_SerieFactura",garantiaBean.getSerieFactura() );
									sentenciaStore.setString("Par_ValorFactura",garantiaBean.getValorFactura() );
									sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(garantiaBean.getFechaRegistro()));

									sentenciaStore.setString("Par_CalleGarante",garantiaBean.getCalleGarante());
									sentenciaStore.setString("Par_NumIntGarante",garantiaBean.getNumIntGarante() );
									sentenciaStore.setString("Par_NumExtGarante",garantiaBean.getNumExtGarante() );
									sentenciaStore.setString("Par_ColoniaGarante",garantiaBean.getColoniaGarante() );
									sentenciaStore.setString("Par_CodPostalGarante",garantiaBean.getCodPostalGarante());

									sentenciaStore.setInt("Par_EstadoIDGarante",Utileria.convierteEntero(garantiaBean.getEstadoGarante()));
									sentenciaStore.setInt("Par_MunicipioGarante",Utileria.convierteEntero(garantiaBean.getMunicipioGarante()));

									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(garantiaBean.getLocalidadIDGarante()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(garantiaBean.getColoniaID()));
									sentenciaStore.setDouble("Par_MontoAvaluo",Utileria.convierteDoble(garantiaBean.getMontoAvaluo()));
									sentenciaStore.setDouble("Par_Proporcion",Utileria.convierteDoble(garantiaBean.getProporcion()));
									sentenciaStore.setString("Par_Usufructuaria", garantiaBean.getUsufructuaria());


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.registerOutParameter("Var_FolioSalida", Types.CHAR);

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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de grarantia", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// ::::::::::::::::  C O N S U L T A S  :::::::::::::::::
	public List clasificacionGarantias(int tipoLista, GarantiaAgroBean garantiaBean){
		String query = "call CLASIFGARANTIASCON (?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getTipoGarantiaID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.clasificacionGarantias",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				// TODO Auto-generated method stub
				GarantiaAgroBean garantiaBean = new GarantiaAgroBean();
				garantiaBean.setClasifGarantiaID(resultSet.getString("ClasifGarantiaID"));
				garantiaBean.setClasifGarantiaDesc(resultSet.getString("Descripcion"));

				return garantiaBean;
			}

		});

		return matches;
	}


	public GarantiaAgroBean consultaPrincipalGarantia(int tipoCon, GarantiaAgroBean garantiaBean){
		String query = "call GARANTIASAGROCON (?,?,?,?,?, ?,?,?,?,?,?,? );";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Utileria.convierteLong(garantiaBean.getSolicitudCreditoID()),
				tipoCon,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.consultaPrincipalGarantia",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTIASAGROCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				// TODO Auto-generated method stub
				GarantiaAgroBean garantiaBean = new GarantiaAgroBean();
				//GarantiaID,	 ProspectoID, ClienteID,	AvalID,	GaranteID,
				garantiaBean.setGarantiaID(resultSet.getString("GarantiaID"));
				garantiaBean.setProspectoID(resultSet.getString("ProspectoID"));
				garantiaBean.setClienteID(resultSet.getString("ClienteID"));
				garantiaBean.setAvalID(resultSet.getString("AvalID"));
				garantiaBean.setGaranteID(resultSet.getString("GaranteID"));

				//TipoGarantiaID,	ClasifGarantiaID,	ValorComercial, Observaciones,
				garantiaBean.setTipoGarantiaID(resultSet.getString("TipoGarantiaID"));
				garantiaBean.setClasifGarantiaID(resultSet.getString("ClasifGarantiaID"));
				garantiaBean.setValorComercial(resultSet.getString("ValorComercial"));
				garantiaBean.setObservaciones(resultSet.getString("Observaciones"));
				//EstadoID,	 MunicipioID,	Calle,	 Numero, NumeroInt,	 Lote,
				garantiaBean.setEstadoID(resultSet.getString("EstadoID"));
				garantiaBean.setMunicipioID(resultSet.getString("MunicipioID"));
				garantiaBean.setCalle(resultSet.getString("Calle"));
				garantiaBean.setNumero(resultSet.getString("Numero"));
				garantiaBean.setNumeroInt(resultSet.getString("NumeroInt"));
				garantiaBean.setLote(resultSet.getString("Lote"));
				//Manzana,	Colonia,	 CodigoPostal,	M2Construccion,	M2Terreno,
				garantiaBean.setManzana(resultSet.getString("Manzana"));
				garantiaBean.setColonia(resultSet.getString("Colonia"));
				garantiaBean.setCodigoPostal(resultSet.getString("CodigoPostal"));
				garantiaBean.setM2Construccion(resultSet.getString("M2Construccion"));
				garantiaBean.setM2Terreno(resultSet.getString("M2Terreno"));
				//Asegurado,	VencimientoPoliza,	FechaValuacion,NumAvaluo,	 NombreValuador,
				garantiaBean.setAsegurado(resultSet.getString("Asegurado"));
				garantiaBean.setVencimientoPoliza(!resultSet.getString("VencimientoPoliza").equals(FECHA_VACIA)?resultSet.getString("VencimientoPoliza"):"");
				garantiaBean.setFechaValuacion(!resultSet.getString("FechaValuacion").equals(FECHA_VACIA)?resultSet.getString("FechaValuacion"):"");
				garantiaBean.setNumAvaluo(resultSet.getString("NumAvaluo"));
				garantiaBean.setNombreValuador(resultSet.getString("NombreValuador"));
				//Verificada, FechaVerificacion,	TipoGravemen,TipoInsCaptacion,	InsCaptacionID,
				garantiaBean.setVerificada(resultSet.getString("Verificada"));
				garantiaBean.setFechaVerificacion(!resultSet.getString("FechaVerificacion").equals(FECHA_VACIA)?resultSet.getString("FechaVerificacion"):"");
				garantiaBean.setTipoGravemen(resultSet.getString("TipoGravemen"));
				garantiaBean.setTipoInsCaptacion(resultSet.getString("TipoInsCaptacion"));
				garantiaBean.setInsCaptacionID(resultSet.getString("InsCaptacionID"));
				///MontoAsignado,	 Estatus
				garantiaBean.setMontoAsignado(resultSet.getString("MontoAsignado"));
				garantiaBean.setEstatus(resultSet.getString("Estatus"));
				garantiaBean.setNumIdentificacion(resultSet.getString("NoIdentificacion"));
				//TipoDocumentoID	, 	Asegurador	  ,		NombreAutoridad	,
				garantiaBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
				garantiaBean.setAsegurador(resultSet.getString("Asegurador"));
				garantiaBean.setNombreAutoridad(resultSet.getString("NombreAutoridad"));
				//CargoAutoridad	  ,	FechaCompFactura  ,FechaGrevemen  ,FolioRegistro ,
				garantiaBean.setCargoAutoridad(resultSet.getString("CargoAutoridad"));
				garantiaBean.setFechaCompFactura(!resultSet.getString("FechaCompFactura").equals(FECHA_VACIA)?resultSet.getString("FechaCompFactura"):"");
				garantiaBean.setFechagravemen(!resultSet.getString("FechaGrevemen").equals(FECHA_VACIA)?resultSet.getString("FechaGrevemen"):"");
				garantiaBean.setFolioRegistro(resultSet.getString("FolioRegistro"));
				//MontoGravemen  ,	NombBenefiGravem , NotarioID  ,	NumPoliza  ,
				garantiaBean.setMontoGravemen(resultSet.getString("MontoGravemen"));
				garantiaBean.setNombBenefiGrav(resultSet.getString("NombBenefiGravem"));
				garantiaBean.setNotarioID(resultSet.getString("NotarioID"));
				garantiaBean.setNumPoliza(resultSet.getString("NumPoliza"));
				//ReferenFactura , 	RFCEmisor  ,SerieFactura ,	ValorFactura ,
				garantiaBean.setReferenciafact(resultSet.getString("ReferenFactura"));
				garantiaBean.setRfcEmisor(resultSet.getString("RFCEmisor"));
				garantiaBean.setSerieFactura(resultSet.getString("SerieFactura"));
				garantiaBean.setValorFactura(resultSet.getString("ValorFactura"));
				garantiaBean.setFechaRegistro(!resultSet.getString("FechaRegistro").equals(FECHA_VACIA)?resultSet.getString("FechaRegistro"):"");
				garantiaBean.setGaranteNombre(resultSet.getString("GaranteNombre"));
				garantiaBean.setSucursalID(resultSet.getString("Sucursal"));

				garantiaBean.setCalleGarante(resultSet.getString("CalleGarante" ));
				garantiaBean.setNumIntGarante(resultSet.getString("NumIntGarante" ) );
				garantiaBean.setNumExtGarante(resultSet.getString("NumExtGarante" ) );
				garantiaBean.setColoniaGarante(resultSet.getString("ColoniaGarante" ) );
				garantiaBean.setCodPostalGarante(resultSet.getString("CodPostalGarante" ));
				garantiaBean.setEstadoGarante(resultSet.getString("EstadoIDGarante"));
				garantiaBean.setMunicipioGarante(resultSet.getString("MunicipioGarante"));

				garantiaBean.setLocalidadIDGarante(resultSet.getString("LocalidadID"));
				garantiaBean.setColoniaID(resultSet.getString("ColoniaID"));
				garantiaBean.setMontoAvaluo(resultSet.getString("MontoAvaluo"));
				garantiaBean.setProporcion(resultSet.getString("Proporcion"));
				garantiaBean.setUsufructuaria(resultSet.getString("Usufructuaria"));
				garantiaBean.setMontoDisponible(resultSet.getString("MontoDisponible"));
				garantiaBean.setMontoGarantia(resultSet.getString("MontoGarantia"));
				garantiaBean.setMontoAvaluado(resultSet.getString("MontoAvaluado"));

				return garantiaBean;
			}
		});
		return matches.size() > 0 ? (GarantiaAgroBean) matches.get(0) : null;
	}

	//LISTA
	public List listaPrincipal( GarantiaAgroBean garantiaBean, int tipoLista){
		String query = "call GARANTIALIS(?,?  ,?,?,?,?,?   ,?,?,?,?,?);";
		Object[] parametros = {
				garantiaBean.getObservaciones().trim(),
				Utileria.convierteEntero(garantiaBean.getClienteID().trim()),
				Utileria.convierteEntero(garantiaBean.getProspectoID().trim()),
				Constantes.STRING_VACIO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTIALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setGarantiaID(resultSet.getString("GarantiaID"));
				garantiaBeanSalida.setObservaciones(resultSet.getString("Observaciones"));
				garantiaBeanSalida.setValorComercial(resultSet.getString("ValorComercial"));

				return garantiaBeanSalida;
			}
		});
		return matches;
	}

	///////////////////////  a s i g n a c i o n /////

	//Alta asignacion de garantia
	public MensajeTransaccionBean  altaAsignacionGarantia(final GarantiaAgroBean garantiaBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL ASIGNAGARANTIASALT(?,?,?,?,?," +
																	   "?,?, " +
																	   "?,?,?," +
																	   "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_SolCredID",Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(garantiaBean.getCreditoID()));
								sentenciaStore.setInt("Par_GarantiaID",Utileria.convierteEntero(garantiaBean.getGarantiaID()));
								sentenciaStore.setDouble("Par_MontoAsignado",Utileria.convierteDoble(garantiaBean.getMontoAsignado()));
								sentenciaStore.setString("Par_Estatus",garantiaBean.getEstatus());

								sentenciaStore.setString("Par_EstatusSolicitud",garantiaBean.getEstatusSolicitud());
								sentenciaStore.setString("Par_SustituyeGL",garantiaBean.getSustituyeGL());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "GarantiasAgroDAO.altaAsignacionGarantia");
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GarantiasDAO.altaAsignacionGarantia");
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
						throw new Exception(Constantes.MSG_ERROR + " .GarantiasDAO.altaAsignacionGarantia");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de asignacion de garantia" + e);
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

	public MensajeTransaccionBean bajaAsignacionGarantia(final GarantiaAgroBean garantiaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call ASIGNAGARANTIASBAJ(?,?,?,?, ?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID()),
							Utileria.convierteLong(garantiaBean.getCreditoID()),
							Utileria.convierteEntero(garantiaBean.getGarantiaID()),
							1,
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GarantiasDAO.bajaAsignacionGarantia",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASBAJ(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							mensaje.setConsecutivoInt(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de asigancion de garantias", e);
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

	public MensajeTransaccionBean bajaAsignacionGarantiaReest(final GarantiaAgroBean garantiaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call ASIGNAGARANTIASBAJ(?,?,?,?, ?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID()),
							Utileria.convierteLong(garantiaBean.getCreditoID()),
							Utileria.convierteEntero(garantiaBean.getGarantiaID()),
							2,
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GarantiasDAO.bajaAsignacionGarantia",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASBAJ(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							mensaje.setConsecutivoInt(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de asigancion de garantias", e);
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

	public List listaGrigAsignacion( GarantiaAgroBean garantiaBean, int tipoLista){

		String query = "call ASIGNAGARANTIASCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong( garantiaBean.getCreditoID().trim()),
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.listaGrigAsignacion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setGarantiaID(resultSet.getString("GarantiaID"));
				garantiaBeanSalida.setObservaciones(resultSet.getString("Observaciones"));
				garantiaBeanSalida.setValorComercial(resultSet.getString("ValorComercial"));
				garantiaBeanSalida.setMontoAsignado(resultSet.getString("MontoAsignado"));
				garantiaBeanSalida.setEstatus(resultSet.getString("Estatus"));
				garantiaBeanSalida.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
				garantiaBeanSalida.setSustituyeGL(resultSet.getString("SustituyeGL"));
				garantiaBeanSalida.setMontoDisponible(resultSet.getString("MontoDisponible"));
				garantiaBeanSalida.setMontoGarantia(resultSet.getString("MontoGarantia"));
				garantiaBeanSalida.setMontoAvaluado(resultSet.getString("MontoAvaluado"));
				return garantiaBeanSalida;
			}
		});
		return matches;
	}


	public List listaGarantiaReest( GarantiaAgroBean garantiaBean, int tipoLista){

		String query = "call ASIGNAGARANTIASCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong( garantiaBean.getCreditoID().trim()),
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.listaGrigAsignacion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setGarantiaID(resultSet.getString("GarantiaID"));
				garantiaBeanSalida.setObservaciones(resultSet.getString("Observaciones"));
				garantiaBeanSalida.setValorComercial(resultSet.getString("ValorComercial"));
				garantiaBeanSalida.setMontoAsignado(resultSet.getString("MontoAsignado"));
				garantiaBeanSalida.setEstatus(resultSet.getString("Estatus"));
				garantiaBeanSalida.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
				garantiaBeanSalida.setMontoDisponible(resultSet.getString("MontoDisponible"));
				garantiaBeanSalida.setMontoGarantia(resultSet.getString("MontoGarantia"));
				garantiaBeanSalida.setMontoAvaluado(resultSet.getString("MontoAvaluado"));
				return garantiaBeanSalida;
			}
		});
		return matches;
	}


	//lista usada en grid de la pnatalla de mesa de control
	public List listaAutorizadas( GarantiaAgroBean garantiaBean, int tipoLista){
		List grid=null;
		try{
			String query = "call ASIGNAGARANTIASLIS(?,?,?,?,? , ?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong(garantiaBean.getCreditoID().trim()),
				tipoLista ,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setGarantiaID(resultSet.getString(1));
				garantiaBeanSalida.setGaranteNombre(resultSet.getString(2));
				garantiaBeanSalida.setValorComercial(resultSet.getString(3));
				garantiaBeanSalida.setObservaciones(resultSet.getString(4));
				garantiaBeanSalida.setNoIdentificacion(resultSet.getString(5));
				garantiaBeanSalida.setSerieFactura(resultSet.getString(6));

				return garantiaBeanSalida;
			}
		});
		grid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de garantia autorizada", e);

		}
		return grid;
	}

	public GarantiaAgroBean productoRequiereGarantia( GarantiaAgroBean garantiaBean, int tipoLista){

		GarantiaAgroBean garantiaBeanRetorno = null;

		try{
		String query = "call ASIGNAGARANTIASCON(?,?,?,?, ?,?,?,?,?,?,? );";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong( garantiaBean.getCreditoID().trim()),
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.productoRequiereGarantia",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setRequiereGarantia(resultSet.getString("RequiereGarantia"));
				garantiaBeanSalida.setEstatus(resultSet.getString("Estatus"));
				garantiaBeanSalida.setRelGarantCred(resultSet.getString("RelGarantCred")==null?"0.00":resultSet.getString("RelGarantCred"));
				return garantiaBeanSalida;
			}
		});
		garantiaBeanRetorno= matches.size() > 0 ? (GarantiaAgroBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error el producto requiere garantia", e);
		}
		return garantiaBeanRetorno;


	}

	public GarantiaAgroBean estaAsignadaGarantia( GarantiaAgroBean garantiaBean, int tipoLista){
		GarantiaAgroBean garantiaBeanRetorno = null;
		try{
		String query = "call ASIGNAGARANTIASCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong( garantiaBean.getCreditoID().trim()),
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.estaAsignadaGarantia",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setCreditoID(resultSet.getString("CreditoID") );
				garantiaBeanSalida.setEstatus(resultSet.getString("Estatus"));

				return garantiaBeanSalida;
			}
		});
		garantiaBeanRetorno= matches.size() > 0 ? (GarantiaAgroBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de asigancion de garantia", e);
		}
		return garantiaBeanRetorno;


	}

	public GarantiaAgroBean estaAsigGarantiaASolicitud( GarantiaAgroBean garantiaBean, int tipoLista){

		GarantiaAgroBean garantiaBeanRetorno = null;

		try{
		String query = "call ASIGNAGARANTIASCON(?,?,?,?, ?,?,?,?,?,?,? );";
		Object[] parametros = {
				Utileria.convierteEntero(garantiaBean.getSolicitudCreditoID().trim()),
				Utileria.convierteLong( garantiaBean.getCreditoID().trim()),
				Utileria.convierteEntero(garantiaBean.getGarantiaID().trim()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GarantiasDAO.estaAsigGarantiaASolicitud",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNAGARANTIASCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantiaBeanSalida = new GarantiaAgroBean();
				garantiaBeanSalida.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID") );


				return garantiaBeanSalida;
			}
		});
		garantiaBeanRetorno= matches.size() > 0 ? (GarantiaAgroBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en asignar garantia a solicitud", e);
		}
		return garantiaBeanRetorno;


	}


	/* Lista de ayuda usada en la pantalla. registro de Garantias, busca por nombre de cliente/prospecto/garante  */
	public List listaCliPro(GarantiaAgroBean garantiaBean, int tipoLista) {
		String query = "call GARANTIALIS(?,?,  ?,?,?,?,?   ,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				garantiaBean.getGarantiaID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTIALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantiaAgroBean garantia = new GarantiaAgroBean();

				garantia.setGarantiaID(resultSet.getString("GarantiaID"));
				garantia.setGaranteNombre(resultSet.getString("GaranteNombre"));
				garantia.setObservaciones(resultSet.getString("Observaciones"));

				return garantia;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean grabaListaGarantias(final GarantiaAgroBean garantiaBean, final List listaGarantias) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {


					mensajeBean = bajaAsignacionGarantia(garantiaBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaGarantias.size(); i++){
						GarantiaAgroBean bean = (GarantiaAgroBean)listaGarantias.get(i);
						mensajeBean = altaAsignacionGarantia(bean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("La Asignación de Garantias se ha Grabado Exitosamente: "+garantiaBean.getSolicitudCreditoID());
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de garantias por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean altaAsignaGarReest(final GarantiaAgroBean garantiaBean, final List listaGarantias){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = bajaAsignacionGarantia(garantiaBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					if(listaGarantias.size() == 0 || listaGarantias.isEmpty()){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(15);
						mensajeBean.setDescripcion("No hay garantías por Asignar.");
						mensajeBean.setNombreControl("solicitudCreditoID");
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaGarantias.size(); i++){
						GarantiaAgroBean garantiaGridBean = (GarantiaAgroBean)listaGarantias.get(i);
						mensajeBean = altaAsignacionGarantia(garantiaGridBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Las Garantias fueron Asignadas Correctamente");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de garantias por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
