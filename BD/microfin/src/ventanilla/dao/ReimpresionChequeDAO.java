package ventanilla.dao;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.ReimpresionChequeBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class ReimpresionChequeDAO extends BaseDAO{


	public ReimpresionChequeDAO(){
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";	

	/* Consuta Cliente por Llave Principal*/
	public ReimpresionChequeBean consultaCheques(int tipoConsulta, ReimpresionChequeBean reimpresionCheque) {
		ReimpresionChequeBean reimpresionChequeBean = null;
		try{
			//Query con el Store Procedure
			String query = "call REIMPRESIONCHEQUESCON(?,?,?,?,?,?,"
											+ "?,?,?,?,?,?,?,?);";			
			Object[] parametros = {	reimpresionCheque.getInstitucionID(),
								reimpresionCheque.getNumCtaBancaria(),
								reimpresionCheque.getFechaEmision(),
								reimpresionCheque.getNumCheque(),
								reimpresionCheque.getCajaCheque(),
								reimpresionCheque.getTipoChequera(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ReimpresionChequeDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REIMPRESIONCHEQUESCON(" + Arrays.toString(parametros) + ")");

		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReimpresionChequeBean reimprimeCheque = new ReimpresionChequeBean();			
				reimprimeCheque.setNumCheque(resultSet.getString("NumeroCheque"));
				reimprimeCheque.setNumCliente(resultSet.getString("ClienteID"));
				reimprimeCheque.setBeneficiario(resultSet.getString("Beneficiario"));
				reimprimeCheque.setMonto(resultSet.getString("Monto"));
				reimprimeCheque.setConcepto(resultSet.getString("Concepto"));
				reimprimeCheque.setReferencia(resultSet.getString("Referencia"));
				reimprimeCheque.setFechaActual(resultSet.getString("FechaActual"));
				reimprimeCheque.setNumTransaccion(resultSet.getString("NumTransaccion"));
				reimprimeCheque.setRutaCheque(resultSet.getString("Var_RutaCheque"));				
				reimprimeCheque.setSucursalCheque(resultSet.getString("SucursalID"));
				reimprimeCheque.setCajaCheque(resultSet.getString("CajaID"));
				reimprimeCheque.setFechaEmisionCheque(resultSet.getString("FechaEmision"));
				reimprimeCheque.setUsuarioCheque(resultSet.getString("UsuarioID"));
				reimprimeCheque.setPolizaCheque(resultSet.getString("Var_Poliza"));
				return reimprimeCheque;
					}
		});
		reimpresionChequeBean= matches.size() > 0 ? (ReimpresionChequeBean) matches.get(0) : null;
	}catch(Exception e){
		
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Reimpresion de Cheques Emitidos", e);
		
	}
	return reimpresionChequeBean;
	}
	
	
	// -- Lista de cheques emitidos --//
	public List listaPrincipal(ReimpresionChequeBean reimpresionChequeBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call REIMPRESIONCHEQUESLIS(?,?,?,?,?,?,  ?,?,?,?,?,?,?,?);";
			Object[] parametros = {	reimpresionChequeBean.getInstitucionID(),
									reimpresionChequeBean.getNumCtaBancaria(),
									reimpresionChequeBean.getFechaEmision(),
									reimpresionChequeBean.getNumCheque(),
									reimpresionChequeBean.getCajaCheque(),
									reimpresionChequeBean.getTipoChequera(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REIMPRESIONCHEQUESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReimpresionChequeBean reimpresionCheque = new ReimpresionChequeBean();			
					reimpresionCheque.setNumCheque(resultSet.getString("NumeroCheque"));
					reimpresionCheque.setBeneficiario(resultSet.getString("Beneficiario"));
					reimpresionCheque.setMonto(resultSet.getString("Monto"));
					reimpresionCheque.setConcepto(resultSet.getString("Concepto"));
					return reimpresionCheque;				
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

	
}
