package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import tesoreria.bean.EstadoCuentaBancosReporteBean;
import general.dao.BaseDAO;
public class EstadoCuentaBancosReporteDAO  extends BaseDAO{
	private String formatoMovs = "P"; //Tipo Formato: P: Pantalla, R: Reporte

	public EstadoCuentaBancosReporteDAO(){
		super();
	} 

	// lista que nos da los movimientos para el estado de cuenta de bancos
	public List listaEstadoCuentaBancos(EstadoCuentaBancosReporteBean tesoreriaMovsReporteBean) {
		List movsEstadoCuenta = null;
		try{
		// en esta lista es necesario el numero de transaccion
		transaccionDAO.generaNumeroTransaccion();
		String query = "call TESORERIAMOVREP(?,?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				tesoreriaMovsReporteBean.getInstitucionID(),
				tesoreriaMovsReporteBean.getNumCtaInstit(), 
				tesoreriaMovsReporteBean.getFecha(), 
				formatoMovs,
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasAhoMovDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(), 
				parametrosAuditoriaBean.getNumeroTransaccion()
				};		    
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESORERIAMOVREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
	
				EstadoCuentaBancosReporteBean tesoreriaMovsReporte = new EstadoCuentaBancosReporteBean();
				tesoreriaMovsReporte.setFechaMov(resultSet.getString(1));
				tesoreriaMovsReporte.setDescripcionMov(resultSet.getString(2));
				tesoreriaMovsReporte.setNatMovimiento(resultSet.getString(3));
				tesoreriaMovsReporte.setReferenciaMov(resultSet.getString(4));
				tesoreriaMovsReporte.setMontoMov(resultSet.getString(5));
				tesoreriaMovsReporte.setSaldoAcumulado(resultSet.getString(6));
				tesoreriaMovsReporte.setCargos(resultSet.getString(7));
				tesoreriaMovsReporte.setAbonos(resultSet.getString(8));
				return tesoreriaMovsReporte;
	
			}
		});
		movsEstadoCuenta =  matches;
		}
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de estado de cuenta", e);
		}
		return movsEstadoCuenta;
	}


}
