package cuentas.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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

import cuentas.bean.TiposCuentaBean;

public class TiposCuentaDAO extends BaseDAO {

	public TiposCuentaDAO() {
		super();
	}

	public MensajeTransaccionBean altaTiposCuenta(final TiposCuentaBean tiposCuenta) {
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
									String query = "call TIPOSCUENTAALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
										    "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDouble("Par_MonedaID", Utileria.convierteDoble(tiposCuenta.getMonedaID()));
									sentenciaStore.setString("Par_Descripcion",tiposCuenta.getDescripcion());
									sentenciaStore.setString("Par_Abreviacion",tiposCuenta.getAbreviacion());
									sentenciaStore.setString("Par_GeneraInteres",tiposCuenta.getGeneraInteres());
									sentenciaStore.setString("Par_TipoInteres",tiposCuenta.getTipoInteres());

									sentenciaStore.setString("Par_EsServicio",tiposCuenta.getEsServicio());
									sentenciaStore.setString("Par_EsBancaria",tiposCuenta.getEsBancaria());
									sentenciaStore.setString("Par_EsConcentra",tiposCuenta.getEsConcentradora());
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposCuenta.getMinimoApertura()));
									sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(tiposCuenta.getComApertura()));

									sentenciaStore.setDouble("Par_ComManejoCta",Utileria.convierteDoble(tiposCuenta.getComManejoCta()));
									sentenciaStore.setDouble("Par_ComAniveRsario",Utileria.convierteDoble(tiposCuenta.getComAniversario()));
									sentenciaStore.setString("Par_CobraBanEle",tiposCuenta.getCobraBanEle());
									sentenciaStore.setString("Par_ParticipaSpei",tiposCuenta.getParticipaSpei());
									sentenciaStore.setString("Par_CobraSpei",tiposCuenta.getCobraSpei());

									sentenciaStore.setString("Par_ComSpeiPerFis",tiposCuenta.getComSpeiPerFis());
									sentenciaStore.setString("Par_ComSpeiPerMor",tiposCuenta.getComSpeiPerMor());
									sentenciaStore.setDouble("Par_ComFalsoCobro",Utileria.convierteDoble(tiposCuenta.getComFalsoCobro()));
									sentenciaStore.setString("Par_ExPrimDispSeg",tiposCuenta.getExPrimDispSeg());
									sentenciaStore.setDouble("Par_ComDispSeg",Utileria.convierteDoble(tiposCuenta.getComDispSeg()));

									sentenciaStore.setDouble("Par_SaldoMinR",Utileria.convierteDoble(tiposCuenta.getSaldoMinReq()));
									sentenciaStore.setString("Par_TipoPersona",tiposCuenta.getTipoPersona());
									sentenciaStore.setString("Par_EsBloqueoAuto",tiposCuenta.getEsBloqueoAuto());
									sentenciaStore.setString("Par_ClasificacionConta",tiposCuenta.getClasificacionConta());
									sentenciaStore.setString("Par_RelacionadoCuenta",tiposCuenta.getRelacionadoCuenta());

									sentenciaStore.setString("Par_RegistroFirmas",tiposCuenta.getRegistroFirmas());
									sentenciaStore.setString("Par_HuellasFirmante",tiposCuenta.getHuellasFirmante());
									sentenciaStore.setString("Par_ConCuenta",tiposCuenta.getConCuenta());
									sentenciaStore.setDouble("Par_GatInformativo",Utileria.convierteDoble(tiposCuenta.getGatInformativo()));
									sentenciaStore.setInt("Par_NivelID",Utileria.convierteEntero(tiposCuenta.getNivelCtaID()));

									sentenciaStore.setString("Par_DireccionOficial", tiposCuenta.getDireccionOficial());
									sentenciaStore.setString("Par_IdenOficial", tiposCuenta.getIdenOficial());
						            sentenciaStore.setString("Par_CheckListExpFisico", tiposCuenta.getCheckListExpFisico());
						            sentenciaStore.setString("Par_LimAbonosMensuales", tiposCuenta.getLimAbonosMensuales());
									sentenciaStore.setDouble("Par_AbonosMenHasta",Utileria.convierteDoble(tiposCuenta.getAbonosMenHasta()));

									sentenciaStore.setString("Par_PerAboAdi", tiposCuenta.getPerAboAdi());
									sentenciaStore.setDouble("Par_AboAdiHas",Utileria.convierteDoble(tiposCuenta.getAboAdiHas()));
									sentenciaStore.setString("Par_LimSaldoCuenta", tiposCuenta.getLimSaldoCuenta());
									sentenciaStore.setDouble("Par_SaldoHasta",Utileria.convierteDoble(tiposCuenta.getSaldoHasta()));
									sentenciaStore.setString("Par_NumRegistroRECA", tiposCuenta.getNumRegistroRECA());

									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposCuenta.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposCuenta.getNombreComercial());
									sentenciaStore.setString("Par_ClaveCNBV",tiposCuenta.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposCuenta.getClaveCNBVAmpCred());
									sentenciaStore.setString("Par_EnvioSMSRetiro", tiposCuenta.getEnvioSMSRetiro());

									sentenciaStore.setDouble("Par_MontoMinSMSRetiro", Utileria.convierteDoble(tiposCuenta.getMontoMinSMSRetiro()));
									//parametro para validar estado civil.
									sentenciaStore.setString("Par_EstadoCivil",tiposCuenta.getEstadoCivil());
									sentenciaStore.setString("Par_NotificacionSms", tiposCuenta.getNotificaSms());
									sentenciaStore.setInt("Par_PlantillaID", Utileria.convierteEntero(tiposCuenta.getPlantillaID()));
									sentenciaStore.setDouble("Par_ComisionSalProm", Utileria.convierteDoble(tiposCuenta.getComisionSalProm()));

									sentenciaStore.setDouble("Par_SaldoPromMinReq", Utileria.convierteDoble(tiposCuenta.getSaldoPromMinReq()));
									sentenciaStore.setString("Par_ExentaCobroSalPromOtros", tiposCuenta.getExentaCobroSalPromOtros());
									sentenciaStore.setString("Par_DepositoActiva",tiposCuenta.getDepositoActiva());
									sentenciaStore.setDouble("Par_MontoDepositoActiva",Utileria.convierteDoble(tiposCuenta.getMontoDepositoActiva()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposCuentaDAO.altaTipoCuentaDAO");
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
							throw new Exception(Constantes.MSG_ERROR + " .TiposCuentaDAO.altaTipoCuentaDAO");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"Error en el Registro de Tipo de Cuenta" + e);
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

	public MensajeTransaccionBean modifica(final TiposCuentaBean tiposCuenta){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TIPOSCUENTAMOD(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoCuentaID",tiposCuenta.getTipoCuentaID());
									sentenciaStore.setDouble("Par_MonedaID",Utileria.convierteDoble(tiposCuenta.getMonedaID()));
									sentenciaStore.setString("Par_Descripcion",tiposCuenta.getDescripcion());
									sentenciaStore.setString("Par_Abreviacion",tiposCuenta.getAbreviacion());
									sentenciaStore.setString("Par_GeneraInteres",tiposCuenta.getGeneraInteres());

									sentenciaStore.setString("Par_TipoInteres",tiposCuenta.getTipoInteres());
									sentenciaStore.setString("Par_EsServicio",tiposCuenta.getEsServicio());
									sentenciaStore.setString("Par_EsBancaria",tiposCuenta.getEsBancaria());
									sentenciaStore.setString("Par_EsConcentra",tiposCuenta.getEsConcentradora());
									sentenciaStore.setDouble("Par_MinimoApertura",Utileria.convierteDoble(tiposCuenta.getMinimoApertura()));

									sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(tiposCuenta.getComApertura()));
									sentenciaStore.setDouble("Par_ComManejoCta",Utileria.convierteDoble(tiposCuenta.getComManejoCta()));
									sentenciaStore.setDouble("Par_ComAniversario",Utileria.convierteDoble(tiposCuenta.getComAniversario()));
									sentenciaStore.setString("Par_CobraBanEle",tiposCuenta.getCobraBanEle());
									sentenciaStore.setString("Par_ParticipaSpei",tiposCuenta.getParticipaSpei());

									sentenciaStore.setString("Par_CobraSpei",tiposCuenta.getCobraSpei());
									sentenciaStore.setString("Par_ComSpeiPerFis",tiposCuenta.getComSpeiPerFis());
									sentenciaStore.setString("Par_ComSpeiPerMor",tiposCuenta.getComSpeiPerMor());
									sentenciaStore.setDouble("Par_ComFalsoCobro",Utileria.convierteDoble(tiposCuenta.getComFalsoCobro()));
									sentenciaStore.setString("Par_ExPrimDispSeg",tiposCuenta.getExPrimDispSeg());

									sentenciaStore.setDouble("Par_ComDispSeg",Utileria.convierteDoble(tiposCuenta.getComDispSeg()));
									sentenciaStore.setDouble("Par_SaldoMinR",Utileria.convierteDoble(tiposCuenta.getSaldoMinReq()));
									sentenciaStore.setString("Par_TipoPersona",tiposCuenta.getTipoPersona());
									sentenciaStore.setString("Par_EsBloqueoAuto",tiposCuenta.getEsBloqueoAuto());
									sentenciaStore.setString("Par_ClasificacionConta",tiposCuenta.getClasificacionConta());

									sentenciaStore.setString("Par_RelacionadoCuenta",tiposCuenta.getRelacionadoCuenta());
									sentenciaStore.setString("Par_RegistroFirmas",tiposCuenta.getRegistroFirmas());
									sentenciaStore.setString("Par_HuellasFirmante",tiposCuenta.getHuellasFirmante());
									sentenciaStore.setString("Par_ConCuenta",tiposCuenta.getConCuenta());
									sentenciaStore.setDouble("Par_GatInformativo",Utileria.convierteDoble(tiposCuenta.getGatInformativo()));

									sentenciaStore.setInt("Par_NivelID",Utileria.convierteEntero(tiposCuenta.getNivelCtaID()));
									sentenciaStore.setString("Par_DireccionOficial", tiposCuenta.getDireccionOficial());
									sentenciaStore.setString("Par_IdenOficial", tiposCuenta.getIdenOficial());
									sentenciaStore.setString("Par_CheckListExpFisico", tiposCuenta.getCheckListExpFisico());
									sentenciaStore.setString("Par_LimAbonosMensuales", tiposCuenta.getLimAbonosMensuales());

									sentenciaStore.setDouble("Par_AbonosMenHasta",Utileria.convierteDoble(tiposCuenta.getAbonosMenHasta()));
									sentenciaStore.setString("Par_PerAboAdi", tiposCuenta.getPerAboAdi());
									sentenciaStore.setDouble("Par_AboAdiHas",Utileria.convierteDoble(tiposCuenta.getAboAdiHas()));
									sentenciaStore.setString("Par_LimSaldoCuenta", tiposCuenta.getLimSaldoCuenta());
									sentenciaStore.setDouble("Par_SaldoHasta",Utileria.convierteDoble(tiposCuenta.getSaldoHasta()));

									sentenciaStore.setString("Par_NumRegistroRECA", tiposCuenta.getNumRegistroRECA());
									sentenciaStore.setString("Par_FechaInscripcion",Utileria.convierteFecha(tiposCuenta.getFechaInscripcion()));
									sentenciaStore.setString("Par_NombreComercial", tiposCuenta.getNombreComercial());
									sentenciaStore.setString("Par_ClaveCNBV",tiposCuenta.getClaveCNBV());
									sentenciaStore.setString("Par_ClaveCNBVAmpCred",tiposCuenta.getClaveCNBVAmpCred());

									sentenciaStore.setString("Par_EnvioSMSRetiro", tiposCuenta.getEnvioSMSRetiro());
									sentenciaStore.setDouble("Par_MontoMinSMSRetiro", Utileria.convierteDoble(tiposCuenta.getMontoMinSMSRetiro()));
									//parametro para validar estado civil.
									sentenciaStore.setString("Par_EstadoCivil",tiposCuenta.getEstadoCivil());
									sentenciaStore.setString("Par_NotificacionSms", tiposCuenta.getNotificaSms());
									sentenciaStore.setInt("Par_PlantillaID", Utileria.convierteEntero(tiposCuenta.getPlantillaID()));

									sentenciaStore.setDouble("Par_ComisionSalProm", Utileria.convierteDoble(tiposCuenta.getComisionSalProm()));
									sentenciaStore.setDouble("Par_SaldoPromMinReq", Utileria.convierteDoble(tiposCuenta.getSaldoPromMinReq()));
									sentenciaStore.setString("Par_ExentaCobroSalPromOtros", tiposCuenta.getExentaCobroSalPromOtros());
									sentenciaStore.setString("Par_DepositoActiva",tiposCuenta.getDepositoActiva());
									sentenciaStore.setDouble("Par_MontoDepositoActiva",Utileria.convierteDoble(tiposCuenta.getMontoDepositoActiva()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposCuentaDAO.modificaTipoCuentaDAO");
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
							throw new Exception(Constantes.MSG_ERROR + " .TiposCuentaDAO.modificaTipoCuentaDAO");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"Error en la Modificacion de Tipo de Cuenta" + e);
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

	public TiposCuentaBean consultaPrincipal(TiposCuentaBean tiposCuenta, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTACON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								tiposCuenta.getTipoCuentaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposCuentaDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
		};
		loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();
				tiposCuenta.setTipoCuentaID(Utileria.completaCerosIzquierda(resultSet.getInt("TipoCuentaID"), TiposCuentaBean.LONGITUD_ID));
				tiposCuenta.setMonedaID(resultSet.getString("MonedaID"));
				tiposCuenta.setDescripcion(resultSet.getString("Descripcion"));
				tiposCuenta.setAbreviacion(resultSet.getString("Abreviacion"));
				tiposCuenta.setGeneraInteres(resultSet.getString("GeneraInteres"));
				tiposCuenta.setTipoInteres(resultSet.getString("TipoInteres"));
				tiposCuenta.setEsServicio(resultSet.getString("EsServicio"));
				tiposCuenta.setEsBancaria(resultSet.getString("EsBancaria"));
				tiposCuenta.setEsConcentradora(resultSet.getString("EsConcentradora"));
				tiposCuenta.setMinimoApertura(resultSet.getString("MinimoApertura"));
				tiposCuenta.setComApertura(resultSet.getString("ComApertura"));
				tiposCuenta.setComManejoCta(resultSet.getString("ComManejoCta"));
				tiposCuenta.setComAniversario(resultSet.getString("ComAniversario"));
				tiposCuenta.setCobraBanEle(resultSet.getString("CobraBanEle"));
				tiposCuenta.setCobraSpei(resultSet.getString("CobraSpei"));
				tiposCuenta.setComFalsoCobro(resultSet.getString("ComFalsoCobro"));
				tiposCuenta.setExPrimDispSeg(resultSet.getString("ExPrimDispSeg"));
				tiposCuenta.setComDispSeg(resultSet.getString("ComDispSeg"));
				tiposCuenta.setSaldoMinReq(resultSet.getString("SaldoMinReq"));
				tiposCuenta.setTipoPersona(resultSet.getString("TipoPersona"));
				tiposCuenta.setEsBloqueoAuto(resultSet.getString("EsBloqueoAuto"));
				tiposCuenta.setClasificacionConta(resultSet.getString("ClasificacionConta"));
				tiposCuenta.setRelacionadoCuenta(resultSet.getString("RelacionadoCuenta"));
				tiposCuenta.setRegistroFirmas(resultSet.getString("RegistroFirmas"));
				tiposCuenta.setHuellasFirmante(resultSet.getString("HuellasFirmante"));
				tiposCuenta.setConCuenta(resultSet.getString("ConCuenta"));
				tiposCuenta.setGatInformativo(resultSet.getString("GatInformativo"));
				tiposCuenta.setParticipaSpei(resultSet.getString("ParticipaSpei"));
				tiposCuenta.setComSpeiPerFis(resultSet.getString("ComSpeiPerFis"));
				tiposCuenta.setComSpeiPerMor(resultSet.getString("ComSpeiPerMor"));
				tiposCuenta.setNivelCtaID(resultSet.getString("NivelID"));
				tiposCuenta.setDireccionOficial(resultSet.getString("DireccionOficial"));
				tiposCuenta.setIdenOficial(resultSet.getString("IdenOficial"));
				tiposCuenta.setCheckListExpFisico(resultSet.getString("CheckListExpFisico"));
				tiposCuenta.setLimAbonosMensuales(resultSet.getString("LimAbonosMensuales"));
				tiposCuenta.setAbonosMenHasta(resultSet.getString("AbonosMenHasta"));
				tiposCuenta.setPerAboAdi(resultSet.getString("PerAboAdi"));
			    tiposCuenta.setAboAdiHas(resultSet.getString("AboAdiHas"));
			    tiposCuenta.setLimSaldoCuenta(resultSet.getString("LimSaldoCuenta"));
			    tiposCuenta.setSaldoHasta(resultSet.getString("SaldoHasta"));
			    tiposCuenta.setNumRegistroRECA(resultSet.getString("NumRegistroRECA"));
			    tiposCuenta.setFechaInscripcion(resultSet.getString("FechaInscripcion"));
			    tiposCuenta.setNombreComercial(resultSet.getString("NombreComercial"));
			    tiposCuenta.setClaveCNBV(resultSet.getString("ClaveCNBV"));
			    tiposCuenta.setClaveCNBVAmpCred(resultSet.getString("ClaveCNBVAmpCred"));
				tiposCuenta.setEnvioSMSRetiro(resultSet.getString("EnvioSMSRetiro"));
				tiposCuenta.setMontoMinSMSRetiro(resultSet.getString("MontoMinSMSRetiro"));
				tiposCuenta.setEstadoCivil(resultSet.getString("EstadoCivil"));
				tiposCuenta.setNotificaSms(resultSet.getString("NotificacionSms"));
				tiposCuenta.setEstatus(String.valueOf(resultSet.getString("Estatus")));
				tiposCuenta.setPlantillaID(String.valueOf(resultSet.getString("PlantillaID")));
				tiposCuenta.setSaldoPromMinReq(resultSet.getString("SaldoPromMinReq"));
				tiposCuenta.setExentaCobroSalPromOtros(resultSet.getString("ExentaCobroSalPromOtros"));
				tiposCuenta.setComisionSalProm(resultSet.getString("ComisionSalProm"));
				tiposCuenta.setDepositoActiva(String.valueOf(resultSet.getString("DepositoActiva")));
				tiposCuenta.setMontoDepositoActiva(String.valueOf(resultSet.getString("MontoDepositoActiva")));
				return tiposCuenta;
			}
		});
		return matches.size() > 0 ? (TiposCuentaBean) matches.get(0) : null;

	}

	public TiposCuentaBean consultaForanea(TiposCuentaBean tiposCuenta, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTACON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tiposCuenta.getTipoCuentaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposCuentaDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();
				tiposCuenta.setTipoCuentaID(resultSet.getString(1));
				tiposCuenta.setDescripcion(resultSet.getString(2));
				tiposCuenta.setMonedaID(resultSet.getString(3));
				tiposCuenta.setClasificacionConta(resultSet.getString("ClasificacionConta"));
				return tiposCuenta;

			}
		});
		return matches.size() > 0 ? (TiposCuentaBean) matches.get(0) : null;

	}

	public TiposCuentaBean consultaTiposCuenta(TiposCuentaBean tiposCuenta, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTACON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								tiposCuenta.getTipoCuentaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposCuentaDAO.consultaTiposCuenta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();

				tiposCuenta.setTipoCuentaID(resultSet.getString(1));
				tiposCuenta.setDescripcion(resultSet.getString(2));
				tiposCuenta.setMonedaID(resultSet.getString(3));
				tiposCuenta.setGeneraInteres(resultSet.getString(4));
				tiposCuenta.setTipoInteres(resultSet.getString(5));
				tiposCuenta.setEsServicio(resultSet.getString(6));
				tiposCuenta.setEsBancaria(resultSet.getString(7));;
				tiposCuenta.setCobraBanEle(resultSet.getString(8));
				tiposCuenta.setCobraSpei(resultSet.getString(9));
				tiposCuenta.setExPrimDispSeg(resultSet.getString(10));
				tiposCuenta.setClasificacionConta(resultSet.getString("ClasificacionConta"));
				return tiposCuenta;

			}
		});
		return matches.size() > 0 ? (TiposCuentaBean) matches.get(0) : null;
	}



public TiposCuentaBean consultaComisionSPEI(TiposCuentaBean tiposCuenta, int tipoConsulta) {
	//Query con el Store Procedure
	String query = "call TIPOSCUENTACON(?,?,?,?,?,?,?,?,?);";
	Object[] parametros = {
							tiposCuenta.getTipoCuentaID(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"TiposCuentaDAO.consultaTiposCuenta",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
	loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTACON(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			TiposCuentaBean tiposCuenta = new TiposCuentaBean();

			tiposCuenta.setTipoCuentaID(resultSet.getString(1));
			tiposCuenta.setParticipaSpei(resultSet.getString(2));
			tiposCuenta.setCobraSpei(resultSet.getString(3));
			tiposCuenta.setComSpeiPerFis(resultSet.getString(4));
			tiposCuenta.setComSpeiPerMor(resultSet.getString(5));

			return tiposCuenta;

		}
	});
	return matches.size() > 0 ? (TiposCuentaBean) matches.get(0) : null;
}

	//Lista
	public List listaPrincipal(TiposCuentaBean tiposCuentaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	tiposCuentaBean.getDescripcion(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TiposCuentaDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};

		loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();
				tiposCuenta.setTipoCuentaID(String.valueOf(resultSet.getInt(1)));;
				tiposCuenta.setDescripcion(resultSet.getString(2));
				return tiposCuenta;
			}
		});

		return matches;
	}

	//Lista de Tipos de Cuenta
	public List listaTiposCuentas(int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTALIS(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	"",tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposCuentaDAO.listaTiposCuentas",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();
				tiposCuenta.setTipoCuentaID(String.valueOf(resultSet.getInt(1)));
				tiposCuenta.setDescripcion(resultSet.getString(2));
				return tiposCuenta;
			}
		});

		return matches;
	}
	//Lista de Tipos de Cuenta
		public List listaTiposCuentas(int tipoLista,TiposCuentaBean tiposCuentaBean ) {
			//Query con el Store Procedure
			String query = "call TIPOSCUENTALIS(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					tiposCuentaBean.getDescripcion(),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposCuentaDAO.listaTiposCuentas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(/*parametrosAuditoriaBean.getOrigenDatos()+"-"+*/"call TIPOSCUENTALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposCuentaBean tiposCuenta = new TiposCuentaBean();
					tiposCuenta.setTipoCuentaID(String.valueOf(resultSet.getInt(1)));
					tiposCuenta.setDescripcion(resultSet.getString(2));
					return tiposCuenta;
				}
			});

			return matches;
		}
	//Lista para reporte Portada del contrato
/*	public List listaPortadaContrato(TiposCuentaBean tiposCuentaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSCUENTALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	tiposCuentaBean.getDescripcion(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TiposCuentaDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
								};


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposCuentaBean tiposCuenta = new TiposCuentaBean();
				tiposCuenta.setTipoCuentaID(String.valueOf(resultSet.getInt(1)));;
				tiposCuenta.setDescripcion(resultSet.getString(2));
				return tiposCuenta;
			}
		});

		return matches;
	}*/

	// Lista de tipos de cuenta que son de nomina
	public List listaCuentasBancarias(int tipoLista) {
		List lista = null;
		try{
			//Query con el Store Procedure
			String query = "call TIPOSCUENTALIS(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposCuentaDAO.listaCuentasBancarias",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCUENTALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					TiposCuentaBean tiposCuenta = new TiposCuentaBean();
					tiposCuenta.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					tiposCuenta.setDescripcion(resultSet.getString("Descripcion"));

					return tiposCuenta;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de tipos cuentas bancarias", e);
		}
		return lista;
	}
}

