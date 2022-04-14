package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.ResultadoSegtoDesProyBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ResultadoSegtoDesProyDAO extends BaseDAO{

	public ResultadoSegtoDesProyDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final ResultadoSegtoDesProyBean resultadoSegtoDesProyBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SEGTOFORMDESPROYALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,  ?,?,?,  ?,?,?,?,?, ?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoPrograID()));
							sentenciaStore.setInt("Par_SegtoRealizaID",Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoRealizaID()));
							sentenciaStore.setString("Par_AsistenciaGpo",resultadoSegtoDesProyBean.getAsistenciaGpo());
							sentenciaStore.setString("Par_AvanceProy",resultadoSegtoDesProyBean.getAvanceProy());
							sentenciaStore.setString("Par_MontoEstProd",resultadoSegtoDesProyBean.getMontoEstProd());

							sentenciaStore.setString("Par_UnidEstProd",resultadoSegtoDesProyBean.getUnidEstProd());
							sentenciaStore.setString("Par_PrecioEstUni",resultadoSegtoDesProyBean.getPrecioEstUni());
							sentenciaStore.setString("Par_MontoEspVtas",resultadoSegtoDesProyBean.getMontoEspVtas());
							sentenciaStore.setString("Par_FechaComercializa",resultadoSegtoDesProyBean.getFechaComercializa());
							sentenciaStore.setString("Par_ReconoceAdeudo",resultadoSegtoDesProyBean.getReconoceAdeudo());

							sentenciaStore.setString("Par_ConoceMtosFechas",resultadoSegtoDesProyBean.getConoceMtosFechas());
							sentenciaStore.setString("Par_TelefonoFijo",resultadoSegtoDesProyBean.getTelefonoFijo());
							sentenciaStore.setString("Par_TelefonoCel",resultadoSegtoDesProyBean.getTelefonoCel());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta captura de cobranza de seguimiento ", e);
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

	public MensajeTransaccionBean modifica(final ResultadoSegtoDesProyBean resultadoSegtoDesProyBean) {
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
						String query = "call SEGTOFORMDESPROYMOD(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoPrograID()));
						sentenciaStore.setInt("Par_SegtoRealizaID",Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoRealizaID()));
						sentenciaStore.setString("Par_AsistenciaGpo",resultadoSegtoDesProyBean.getAsistenciaGpo());
						sentenciaStore.setString("Par_AvanceProy",resultadoSegtoDesProyBean.getAvanceProy());
						sentenciaStore.setString("Par_MontoEstProd",resultadoSegtoDesProyBean.getMontoEstProd());

						sentenciaStore.setString("Par_UnidEstProd",resultadoSegtoDesProyBean.getUnidEstProd());
						sentenciaStore.setString("Par_PrecioEstUni",resultadoSegtoDesProyBean.getPrecioEstUni());
						sentenciaStore.setString("Par_MontoEspVtas",resultadoSegtoDesProyBean.getMontoEspVtas());
						sentenciaStore.setString("Par_FechaComercializa",resultadoSegtoDesProyBean.getFechaComercializa());
						sentenciaStore.setString("Par_ReconoceAdeudo",resultadoSegtoDesProyBean.getReconoceAdeudo());

						sentenciaStore.setString("Par_ConoceMtosFechas",resultadoSegtoDesProyBean.getConoceMtosFechas());
						sentenciaStore.setString("Par_TelefonoFijo",resultadoSegtoDesProyBean.getTelefonoFijo());
						sentenciaStore.setString("Par_TelefonoCel",resultadoSegtoDesProyBean.getTelefonoCel());

						sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

						sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
						sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
						sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
						sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
						sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
						sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
						sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EsquemaComPrepagoCreditoDAO.modifica");
							mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion De captura de seguimiento de cobranza", e);

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

	public ResultadoSegtoDesProyBean consultaPrincipal(ResultadoSegtoDesProyBean resultadoSegtoDesProyBean, int tipoConsulta) {
		ResultadoSegtoDesProyBean resultadoSegtoDesProyConsulta = new ResultadoSegtoDesProyBean();
		try{
			//Query con el Store Procedure
			String query = "call SEGTOFORMDESPROYCON(?,? ,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoPrograID()),
							Utileria.convierteEntero(resultadoSegtoDesProyBean.getSegtoRealizaID()),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ResultadoSegtoDesProyDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOFORMDESPROYCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ResultadoSegtoDesProyBean resultadoSegtoDesProy = new ResultadoSegtoDesProyBean();
					resultadoSegtoDesProy.setSegtoPrograID(String.valueOf(resultSet.getInt("SegtoPrograID")));
					resultadoSegtoDesProy.setSegtoRealizaID(String.valueOf(resultSet.getInt("SegtoRealizaID")));
					resultadoSegtoDesProy.setAsistenciaGpo(resultSet.getString("AsistenciaGpo"));
					resultadoSegtoDesProy.setAvanceProy(resultSet.getString("AvanceProy"));
					resultadoSegtoDesProy.setMontoEstProd(resultSet.getString("MontoEstProd"));
					resultadoSegtoDesProy.setUnidEstProd(resultSet.getString("UnidEstProd"));
					resultadoSegtoDesProy.setPrecioEstUni(resultSet.getString("PrecioEstUni"));
					resultadoSegtoDesProy.setMontoEspVtas(resultSet.getString("MontoEspVtas"));
					resultadoSegtoDesProy.setFechaComercializa(resultSet.getString("FechaComercializa"));
					resultadoSegtoDesProy.setReconoceAdeudo(resultSet.getString("ReconoceAdeudo"));
					resultadoSegtoDesProy.setConoceMtosFechas(resultSet.getString("ConoceMtosFechas"));
					resultadoSegtoDesProy.setTelefonoFijo(resultSet.getString("TelefonoFijo"));
					resultadoSegtoDesProy.setTelefonoCel(resultSet.getString("TelefonoCel"));
					return resultadoSegtoDesProy;
				}
			});
			resultadoSegtoDesProyConsulta = matches.size() > 0 ? (ResultadoSegtoDesProyBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal", e);
		}
		return resultadoSegtoDesProyConsulta;
	}
}
