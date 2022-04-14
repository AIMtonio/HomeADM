package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.EjercicioContableBean;
import contabilidad.bean.PeriodoContableBean;


public class EjercicioContableDAO extends BaseDAO {
	// ------------------ Atributos ------------------------------------------
	PeriodoContableDAO periodoContableDAO = null;
	
	public EjercicioContableDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	/* Consuta Ejercicio Vigente */
	public EjercicioContableBean  consultaEjercicioVigente(EjercicioContableBean ejercicioContable,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call EJERCICIOCONTABLECON(?,?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				Constantes.ENTERO_CERO,//ejercicioContable.getNumeroEjercicio(),
				ejercicioContable.getTipoEjercicio(),
				ejercicioContable.getInicioEjercicio(),
				ejercicioContable.getFinEjercicio(),
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EjercicioContableDAO.consultaEjercicioVigente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EJERCICIOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
					EjercicioContableBean ejercicioContableBean = new EjercicioContableBean();
					ejercicioContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
					ejercicioContableBean.setTipoEjercicio(resultSet.getString(2));
					ejercicioContableBean.setInicioEjercicio(String.valueOf(resultSet.getDate(3)));					
					ejercicioContableBean.setFinEjercicio(String.valueOf(resultSet.getDate(4)));
					return ejercicioContableBean;
			}
		});	
		return matches.size() > 0 ? (EjercicioContableBean) matches.get(0) : null;
	}
	
	/* Consuta Ejercicio Vigente */
	public EjercicioContableBean consultaEjercicio(EjercicioContableBean ejercicioContableBean,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call EJERCICIOCONTABLECON(?,?,?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				ejercicioContableBean.getNumeroEjercicio(),
				ejercicioContableBean.getTipoEjercicio(),
				ejercicioContableBean.getInicioEjercicio(),
				ejercicioContableBean.getFinEjercicio(),
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EjercicioContableDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EJERCICIOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
					EjercicioContableBean ejercicioContableBean = new EjercicioContableBean();
					ejercicioContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
					ejercicioContableBean.setTipoEjercicio(resultSet.getString(2));
					ejercicioContableBean.setInicioEjercicio(String.valueOf(resultSet.getDate(3)));					
					ejercicioContableBean.setFinEjercicio(String.valueOf(resultSet.getDate(4)));
					return ejercicioContableBean;
			}
		});	
		return matches.size() > 0 ? (EjercicioContableBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean altaEjercicio(final EjercicioContableBean ejercicioContableBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		try{
		
			String query = "call EJERCICIOCONTABLEALT(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {					
					ejercicioContableBean.getTipoEjercicio(),
					ejercicioContableBean.getInicioEjercicio(),
					ejercicioContableBean.getFinEjercicio(),
					parametrosAuditoriaBean.getEmpresaID(),
					
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"EjercicioContableDAO.altaEjercicio",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EJERCICIOCONTABLEALT(" + Arrays.toString(parametros) + ")");
	
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
			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {
		
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de ejercicio contable", e);
		}
		return mensaje;		
	}
	
	
	public MensajeTransaccionBean grabaEjercicioPeriodos(final EjercicioContableBean ejercicioContableBean,
														 final List listaPeriodos ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
										
					mensajeBean = altaEjercicio(ejercicioContableBean);
					
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String numeroEjercicio = mensajeBean.getConsecutivoString();
					PeriodoContableBean periodoBean;
					for(int i=0; i<listaPeriodos.size(); i++){
						periodoBean = (PeriodoContableBean)listaPeriodos.get(i);
						periodoBean.setNumeroEjercicio(numeroEjercicio);
						mensajeBean = periodoContableDAO.altaPeriodo(periodoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());	
						}											
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada Correctamente.");
					mensajeBean.setNombreControl("inicioEjercicio");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la transaccion de periodos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public void setPeriodoContableDAO(PeriodoContableDAO periodoContableDAO) {
		this.periodoContableDAO = periodoContableDAO;
	}
	
	/* Lista por periodo de los Periodos Contables */
	public List listaPorEjercicio(int tipoLista) {
		//Query con el Store Procedure
		String query = "call EJERCICIOCONTABLELIS(? ,?,?,?,?,?,?);";
		Object[] parametros = {	
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"EjercicioContableDAO.listaPorEjercicio",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EJERCICIOCONTABLELIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EjercicioContableBean ejercicioContableBean = new EjercicioContableBean();					
				ejercicioContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
				ejercicioContableBean.setInicioEjercicio(resultSet.getString(2));
				ejercicioContableBean.setFinEjercicio(resultSet.getString(3));
				ejercicioContableBean.setFechaCierre(resultSet.getString(4));
				ejercicioContableBean.setStatus(resultSet.getString(5));
				return ejercicioContableBean;
			}
		});
				
		return matches;
	}	
	
	// ------------------ Getters y Setters ------------------------------------------
	
	
}
