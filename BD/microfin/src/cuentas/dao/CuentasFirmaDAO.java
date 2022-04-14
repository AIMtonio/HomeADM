package cuentas.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import cliente.bean.ClienteBean;
import cuentas.bean.CuentasFirmaBean;

public class CuentasFirmaDAO extends BaseDAO  {

	public CuentasFirmaDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final CuentasFirmaBean cuentasFirma) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call CUENTASFIRMAALT(?,?,?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteLong(cuentasFirma.getCuentaAhoID()),
							Utileria.convierteEntero(cuentasFirma.getPersonaID()),
							cuentasFirma.getNombreCompleto(),
							cuentasFirma.getTipo(),
							cuentasFirma.getInstrucEspecial(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CuentasFirmaDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMAALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de firma", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean baja(final CuentasFirmaBean cuentasFirma) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call CUENTASFIRMABAJ(? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteLong(cuentasFirma.getCuentaAhoID()),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CuentasFirmaDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMABAJ(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de cuentas de firma", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean grabaListaFirmantes(final CuentasFirmaBean cuentasFirmaBean, final List listaFirmantes ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					CuentasFirmaBean FirmaBean;
					mensajeBean = baja(cuentasFirmaBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaFirmantes.size(); i++){
						FirmaBean = (CuentasFirmaBean)listaFirmantes.get(i);
						mensajeBean = alta(FirmaBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("cuentaAhoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en grabacion de listas firmantes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public CuentasFirmaBean consultaPrincipal(CuentasFirmaBean cuentasFirmaBean, int tipoConsulta){
		String query = "call CUENTASFIRMACON(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasFirmaBean.getCuentaAhoID(),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasFirmaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
				cuentasFirmaBean.setCuentaFirmaID(Utileria.completaCerosIzquierda(resultSet.getInt(1),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(2),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(3),ClienteBean.LONGITUD_ID));
				cuentasFirmaBean.setNombreCompleto(resultSet.getString(4));
				cuentasFirmaBean.setTipo(resultSet.getString(5));
				cuentasFirmaBean.setInstrucEspecial(resultSet.getString(6));
				return cuentasFirmaBean;
			}
		});
		return matches.size() > 0 ? (CuentasFirmaBean) matches.get(0) : null;
	}

	public List listaPrincipal(CuentasFirmaBean cuentasFirmaBean, int tipoLista){

		String query = "call CUENTASFIRMALIS(?,?,? ,?,?,?,?,?,?,?);";

		Object[] parametros = {
					cuentasFirmaBean.getCuentaAhoID(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasFirmaDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
				cuentasFirmaBean.setCuentaFirmaID(Utileria.completaCerosIzquierda(resultSet.getInt(1),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(2),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(3),ClienteBean.LONGITUD_ID));
				cuentasFirmaBean.setNombreCompleto(resultSet.getString(4));
				cuentasFirmaBean.setTipo(resultSet.getString(5));
				cuentasFirmaBean.setInstrucEspecial(resultSet.getString(6));
				cuentasFirmaBean.setRfc(resultSet.getString(7));
				return cuentasFirmaBean;
			}
		});
		return matches;
	}


	public List listaForanea(CuentasFirmaBean cuentasFirmaBean, int tipoLista){
		String query = "call CUENTASFIRMALIS(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasFirmaBean.getCuentaAhoID(),
					cuentasFirmaBean.getPersonaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasFirmaDAO.listaForanea",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				byte[] firmaVacia = {};

				CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
				cuentasFirmaBean.setCuentaFirmaID(Utileria.completaCerosIzquierda(resultSet.getInt(1),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setNombreCompleto(resultSet.getString(2));
				cuentasFirmaBean.setEsFirmante(resultSet.getString(3));
				cuentasFirmaBean.setDedoHuellaUno(resultSet.getString(4));
				cuentasFirmaBean.setDedoHuellaDos(resultSet.getString(5));
				cuentasFirmaBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				cuentasFirmaBean.setEstatus(resultSet.getString("Estatus"));
				cuentasFirmaBean.setTipoFirmante(resultSet.getString(3));
				cuentasFirmaBean.setPersonaID(String.valueOf(resultSet.getInt("PersonaID")));

				if(resultSet.getBytes("HuellaDos") != null){
					cuentasFirmaBean.setHuellaDos(resultSet.getBytes("HuellaDos"));
				}else{
					cuentasFirmaBean.setHuellaDos(firmaVacia);
				}

				if(resultSet.getBytes("HuellaUno") != null){
					cuentasFirmaBean.setHuellaUno(resultSet.getBytes("HuellaUno"));
				}else{
					cuentasFirmaBean.setHuellaUno(firmaVacia);
				}

				return cuentasFirmaBean;
			}
		});
		return matches;
	}


	public CuentasFirmaBean consultaForanea(CuentasFirmaBean cuentasFirmaBean, int tipoConsulta){
		String query = "call CUENTASFIRMACON(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasFirmaBean.getCuentaAhoID(),
				cuentasFirmaBean.getPersonaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasFirmaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
				cuentasFirmaBean.setCuentaFirmaID(Utileria.completaCerosIzquierda(resultSet.getInt(1),CuentasFirmaBean.LONGITUD_ID));
				cuentasFirmaBean.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(2),ClienteBean.LONGITUD_ID));
				cuentasFirmaBean.setNombreCompleto(resultSet.getString(3));
				cuentasFirmaBean.setClienteID(resultSet.getString(4));
				cuentasFirmaBean.setEsFirmante(resultSet.getString(5));
				return cuentasFirmaBean;
			}
		});
		return matches.size() > 0 ? (CuentasFirmaBean) matches.get(0) : null;
	}

	public List listaHuellaFirmantes(CuentasFirmaBean cuentasFirmaBean, int tipoLista){
		String query = "call CUENTASFIRMALIS(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasFirmaBean.getCuentaAhoID(),
					cuentasFirmaBean.getPersonaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasFirmaDAO.listaHuellaFirmantes",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASFIRMALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasFirmaBean cuentasFirmaBean = new CuentasFirmaBean();
				byte[] firmaVacia = {};

				cuentasFirmaBean.setNombreCompleto(resultSet.getString("NombreFirmante"));
				cuentasFirmaBean.setTipoFirmante(resultSet.getString("TipoFirmante"));
				cuentasFirmaBean.setPersonaID(String.valueOf(resultSet.getInt("PersonaID")));
				cuentasFirmaBean.setDedoHuellaUno(resultSet.getString("DedoHuellaUno"));
				cuentasFirmaBean.setDedoHuellaDos(resultSet.getString("DedoHuellaDos"));

				if(resultSet.getBytes("HuellaDos") != null){
					cuentasFirmaBean.setHuellaDos(resultSet.getBytes("HuellaDos"));
				}else{
					cuentasFirmaBean.setHuellaDos(firmaVacia);
				}

				if(resultSet.getBytes("HuellaUno") != null){
					cuentasFirmaBean.setHuellaUno(resultSet.getBytes("HuellaUno"));
				}else{
					cuentasFirmaBean.setHuellaUno(firmaVacia);
				}


				return cuentasFirmaBean;
			}

		});
		return matches;
	}

	public MensajeTransaccionBean actualizaImpFirmas(final CuentasFirmaBean cuentasFirma, final int tipo_Opcion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call FIRMASIMPRESIONFITPRO(?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_Cuenta", Utileria.convierteLong(cuentasFirma.getCuentaAhoID()));
								sentenciaStore.setInt("Par_Opcion", tipo_Opcion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CargosDAO.alta");
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento FIRMASIMPRESIONFITPRO no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento FIRMASIMPRESIONFITPRO no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en FIRMASIMPRESIONFITPRO", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
					return mensajeBean;
				}
			});
			return mensaje;
		}
}
