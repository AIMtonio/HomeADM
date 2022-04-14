package nomina.dao;

import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.ClienteBean;

import org.springframework.jdbc.core.JdbcTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.AfiliacionBajaCtasClabeBean;

public class AfiliacionBajaCtasClabeDAO extends BaseDAO{
	public ParametrosSesionBean parametrosSesionBean = null;
	public AfiliacionBajaCtasClabeDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	private String nombreArchivo;

public MensajeTransaccionBean grabaLista( final List listaParametros,final int tipoActualizacion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean;
					AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabe;

						if(listaParametros.size()>0){

							for(int i=0; i < listaParametros.size(); i++){
								afiliacionBajaCtasClabe = new AfiliacionBajaCtasClabeBean();
								afiliacionBajaCtasClabe = (AfiliacionBajaCtasClabeBean) listaParametros.get(i);
								if(afiliacionBajaCtasClabe.getIdentificacion().equals("") || afiliacionBajaCtasClabe.getIdentificacion() == null){
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("El Número de Identificación Oficial del Cliente "+ afiliacionBajaCtasClabe.getClienteID()+" No está Registrado.");
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							mensajeBean = altaAfiliaCabecera((AfiliacionBajaCtasClabeBean)listaParametros.get(0), tipoActualizacion);
							if(mensajeBean.getNumero()== 0){

								 nombreArchivo = mensajeBean.getDescripcion();

							for(int i=0; i < listaParametros.size(); i++){
								afiliacionBajaCtasClabeBean = new AfiliacionBajaCtasClabeBean();
								afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) listaParametros.get(i);
								afiliacionBajaCtasClabeBean.setFolioAfiliacion(mensajeBean.getConsecutivoString());
								// alta de registro  regulatorio
								mensajeBean= altaAfiliaDetalle(afiliacionBajaCtasClabeBean, tipoActualizacion);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							}else{
								throw new Exception(mensajeBean.getDescripcion());
							}
						 }else{
							mensajeBean.setDescripcion("Lista de Cuentas de Afiliacion Vacía");
							throw new Exception(mensajeBean.getDescripcion());
						}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Alta de Afiliación/Baja de Cuentas", e);
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

	}// fin de graba registros del regulatorio A1011
	// inicio de alta de registro regulatorio
	public MensajeTransaccionBean altaAfiliaCabecera(final AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean, final int tipoAlta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call AFILIABAJACTADOMALT(" +
										"?,?,?,?,?,  ?,?,?,?,?," +
										"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_FechaRegistro",afiliacionBajaCtasClabeBean.getFechaRegistro());
									sentenciaStore.setString("Par_Estatus",afiliacionBajaCtasClabeBean.getEstatus());
									sentenciaStore.setString("Par_TipoOperacion",afiliacionBajaCtasClabeBean.getTipoAfiliacion());

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

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AfiliacionBajaCtasClabeDAO.altaAfiliaCabecera");
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
							throw new Exception(Constantes.MSG_ERROR + " .AfiliacionBajaCtasClabeDAO.altaRegistro");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Registro AfiliacionBajaCtasClabe" + e);
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


	public MensajeTransaccionBean altaAfiliaDetalle(final AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean, final int tipoAlta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DETAFILIABAJACTADOMALT(" +
										"?,?,?,?,?,  ?,?,?,?,?," +
										"?,?,?,?,?,  ?,?,?,?,?," +
										"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioAfiliacion",Utileria.convierteLong(afiliacionBajaCtasClabeBean.getFolioAfiliacion()));
									sentenciaStore.setString("Par_Referencia",afiliacionBajaCtasClabeBean.getReferencia());
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getClienteID()));
									sentenciaStore.setString("Par_NombreCompleto",afiliacionBajaCtasClabeBean.getNombreCompleto());
									sentenciaStore.setString("Par_EsNomina",afiliacionBajaCtasClabeBean.getEsNomina());

									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getInstitNominaID()));
									sentenciaStore.setString("Par_NombreEmpNomina",afiliacionBajaCtasClabeBean.getNombreEmpNomina());
									sentenciaStore.setInt("Par_InstitBancaria",Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getInstitBancariaID()));
									sentenciaStore.setString("Par_NombreBanco",afiliacionBajaCtasClabeBean.getNombreBanco());
									sentenciaStore.setString("Par_Clabe",afiliacionBajaCtasClabeBean.getClabe());

									sentenciaStore.setString("Par_Convenio",afiliacionBajaCtasClabeBean.getConvenio());
									sentenciaStore.setString("Par_Comentario",afiliacionBajaCtasClabeBean.getComentario());

									sentenciaStore.setString("Par_EstatusDomicilia",afiliacionBajaCtasClabeBean.getEstatusDomicilia());
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

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AfiliacionBajaCtasClabeDAO.altaAfiliaDetalle");
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
							throw new Exception(Constantes.MSG_ERROR + " .AfiliacionBajaCtasClabeDAO.altaAfiliaDetalle");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Detalle Registro AfiliacionBajaCtasClabe" + e);
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

	public AfiliacionBajaCtasClabeBean consultaArchivo(AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean, int tipoConsulta){
		String query = "call AFILIABAJACTADOMCON(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getFolioAfiliacion()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AfiliaClienteNominaDAO.consultaArchivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIABAJACTADOMCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = new AfiliacionBajaCtasClabeBean();

				afiliacionBajaCtasClabeBean.setNombreArchivo(resultSet.getString("NombreArchivo"));
				afiliacionBajaCtasClabeBean.setClabeBancoInst(resultSet.getString("ClabeBancoInst"));
				afiliacionBajaCtasClabeBean.setFolioBanco(resultSet.getString("FolioBanco"));
				afiliacionBajaCtasClabeBean.setTipoAfiliacion(resultSet.getString("TipoOperacion"));

				return afiliacionBajaCtasClabeBean;
			}
		});

		return matches.size() > 0 ? (AfiliacionBajaCtasClabeBean) matches.get(0) : null;

	}

	public AfiliacionBajaCtasClabeBean consultaAfiliacion(AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean, int tipoConsulta){
		String query = "call AFILIABAJACTADOMCON(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getFolioAfiliacion()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AfiliaClienteNominaDAO.consultaArchivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIABAJACTADOMCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = new AfiliacionBajaCtasClabeBean();

				afiliacionBajaCtasClabeBean.setFolioAfiliacion(resultSet.getString("FolioAfiliacion"));
				afiliacionBajaCtasClabeBean.setClienteID(resultSet.getString("ClienteID"));
				afiliacionBajaCtasClabeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				afiliacionBajaCtasClabeBean.setEsNomina(resultSet.getString("EsNomina"));
				afiliacionBajaCtasClabeBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
				afiliacionBajaCtasClabeBean.setNombreEmpNomina(resultSet.getString("NombreEmpNomina"));
				afiliacionBajaCtasClabeBean.setConvenio(resultSet.getString("Convenio"));
				afiliacionBajaCtasClabeBean.setEstatus(resultSet.getString("Estatus"));
				afiliacionBajaCtasClabeBean.setTipoAfiliacion(resultSet.getString("TipoOperacion"));

				return afiliacionBajaCtasClabeBean;
			}
		});

		return matches.size() > 0 ? (AfiliacionBajaCtasClabeBean) matches.get(0) : null;

	}




	public AfiliacionBajaCtasClabeBean consultaPrincipal(AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean, int tipoConsulta){
		String query = "call AFILIACLIENTENOMINACON(" +
				"?,?,?,?,?, ?,?,?,?,?, ?);";
		Object[] parametros = {
				Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getClienteID()),
				Utileria.convierteEntero(afiliacionBajaCtasClabeBean.getInstitNominaID()),
				afiliacionBajaCtasClabeBean.getTipoAfiliacion(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AfiliaClienteNominaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIACLIENTENOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = new AfiliacionBajaCtasClabeBean();

				afiliacionBajaCtasClabeBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"), afiliacionBajaCtasClabeBean.LONGITUD_ID));
				afiliacionBajaCtasClabeBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return afiliacionBajaCtasClabeBean;
			}
		});

		return matches.size() > 0 ? (AfiliacionBajaCtasClabeBean) matches.get(0) : null;

	}
	/* Lista de Clientes por Nombre segun si estan en Nomina o no*/
	public List listaPrincipal(AfiliacionBajaCtasClabeBean afiliaClienteNominaBean, int tipoLista) {
		//Query con el Store Procedure

		String query = "call AFILIACLIENTENOMINALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								afiliaClienteNominaBean.getNombreCompleto(),
								tipoLista,
								afiliaClienteNominaBean.getInstitNominaID(),
								afiliaClienteNominaBean.getEstatus(),
								afiliaClienteNominaBean.getConvenio(),
								afiliaClienteNominaBean.getEsNomina(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIACLIENTENOMINALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AfiliacionBajaCtasClabeBean cliente = new AfiliacionBajaCtasClabeBean();
				cliente.setClienteID(Utileria.completaCerosIzquierda(
				resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}

	public List listaClientesTodos(final AfiliacionBajaCtasClabeBean afiliaClienteNominaBean, int tipoLista) {
		//Query con el Store Procedure

		String query = "call AFILIACLIENTENOMINALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	afiliaClienteNominaBean.getClienteID(),
								Constantes.STRING_VACIO,
								tipoLista,
								afiliaClienteNominaBean.getInstitNominaID(),
								afiliaClienteNominaBean.getTipoAfiliacion(),
								afiliaClienteNominaBean.getConvenio(),
								afiliaClienteNominaBean.getEsNomina(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIACLIENTENOMINALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AfiliacionBajaCtasClabeBean afiliaClienteNominaBeanRes = new AfiliacionBajaCtasClabeBean();
				afiliaClienteNominaBeanRes.setClabe(resultSet.getString("Clabe"));
				afiliaClienteNominaBeanRes.setClienteID(Utileria.completaCerosIzquierda(
				resultSet.getInt("ClienteID"),afiliaClienteNominaBeanRes.LONGITUD_ID));
				afiliaClienteNominaBeanRes.setRfc(resultSet.getString("RFCOficial"));
				afiliaClienteNominaBeanRes.setReferencia(resultSet.getString("Referencia"));
				afiliaClienteNominaBeanRes.setFolio(resultSet.getString("Folio"));
				afiliaClienteNominaBeanRes.setNombreCompleto(resultSet.getString("NombreCompleto"));
				afiliaClienteNominaBeanRes.setTipoPersona(resultSet.getString("TipoPersona"));
				afiliaClienteNominaBeanRes.setInstitBancariaID(resultSet.getString("InstitucionID"));
				afiliaClienteNominaBeanRes.setNombreBanco(resultSet.getString("NombreCorto"));
				afiliaClienteNominaBeanRes.setInstitNominaID(resultSet.getString("InstitNominaID"));
				afiliaClienteNominaBeanRes.setNombreEmpNomina(resultSet.getString("NombreInstit"));
				afiliaClienteNominaBeanRes.setEstatusDomicilia(resultSet.getString("EstatusDomici"));
				afiliaClienteNominaBeanRes.setMontoMaximoCobro(resultSet.getString("MontoMaxCobro"));
				afiliaClienteNominaBeanRes.setTipoCuentaSpei(resultSet.getString("TipoCuentaSpei"));
				afiliaClienteNominaBeanRes.setIdentificacion(resultSet.getString("NumIdentific"));
				afiliaClienteNominaBeanRes.setNumIdentificacion(resultSet.getString("TipoIdentiID"));
				afiliaClienteNominaBeanRes.setConvenio(resultSet.getString("Convenio"));

				//campos agregados para registrar la informacion si es que se guardara
				afiliaClienteNominaBeanRes.setEstatus(afiliaClienteNominaBean.getEstatus());
				afiliaClienteNominaBeanRes.setTipoAfiliacion(afiliaClienteNominaBean.getTipoAfiliacion());
				afiliaClienteNominaBeanRes.setFechaRegistro(afiliaClienteNominaBean.getFechaRegistro());
				afiliaClienteNominaBeanRes.setEsNomina(afiliaClienteNominaBean.getEsNomina());
				return afiliaClienteNominaBeanRes;
			}
		});
		return matches;
	}

	public List listaConvenios(AfiliacionBajaCtasClabeBean afiliaClienteNominaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call AFILIACLIENTENOMINALIS(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoLista,
								afiliaClienteNominaBean.getInstitNominaID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIACLIENTENOMINALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AfiliacionBajaCtasClabeBean afiliaClienteNominaBean = new AfiliacionBajaCtasClabeBean();
				afiliaClienteNominaBean.setConvenio(resultSet.getString("ConvenioNominaID"));
				return afiliaClienteNominaBean;
			}
		});

		return matches;
	}

	/*Lista de folios para el campo Folio Afiliacion*/
	public List listaAfiliaciones(AfiliacionBajaCtasClabeBean afiliaClienteNominaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call AFILIABAJACTADOMLIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								afiliaClienteNominaBean.getNombreArchivo(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIABAJACTADOMLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AfiliacionBajaCtasClabeBean afiliaClienteNominaBean = new AfiliacionBajaCtasClabeBean();
				afiliaClienteNominaBean.setFolioAfiliacion(resultSet.getString("FolioAfiliacion"));
				afiliaClienteNominaBean.setNombreArchivo(resultSet.getString("NombreArchivo"));
				return afiliaClienteNominaBean;
			}
		});

		return matches;
	}

	/*lista cuando se consulta el folio para llenar el grido con datos ya existentes*/
	public List listaAfiliacionesGrid(AfiliacionBajaCtasClabeBean afiliaClienteNominaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call DETAFILIABAJACTADOMLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	afiliaClienteNominaBean.getFolioAfiliacion(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AFILIABAJACTADOMLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AfiliacionBajaCtasClabeBean afiliaClienteNominaBean = new AfiliacionBajaCtasClabeBean();
				afiliaClienteNominaBean.setFolioAfiliacion(resultSet.getString("FolioAfiliacion"));
				afiliaClienteNominaBean.setReferencia(resultSet.getString("Referencia"));
				afiliaClienteNominaBean.setClienteID(resultSet.getString("ClienteID"));
				afiliaClienteNominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				afiliaClienteNominaBean.setEsNomina(resultSet.getString("EsNomina"));
				afiliaClienteNominaBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
				afiliaClienteNominaBean.setNombreEmpNomina(resultSet.getString("NombreEmpNomina"));
				afiliaClienteNominaBean.setInstitBancariaID(resultSet.getString("InstitBancaria"));
				afiliaClienteNominaBean.setNombreBanco(resultSet.getString("NombreBanco"));
				afiliaClienteNominaBean.setClabe(resultSet.getString("Clabe"));
				afiliaClienteNominaBean.setConvenio(resultSet.getString("Convenio"));
				afiliaClienteNominaBean.setComentario(resultSet.getString("Comentario"));
				afiliaClienteNominaBean.setEstatusDomicilia(resultSet.getString("EstatusDomicilia"));
				return afiliaClienteNominaBean;
			}
		});

		return matches;
	}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}




}
