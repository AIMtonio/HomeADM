package tesoreria.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import tesoreria.bean.RepSaldoBancosCCBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class RepSaldoBancosCCDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean=null;

	public RepSaldoBancosCCDAO () {
		super();
	}
	 
	//reporte de saldos de bancos Sumarizado
	public List listaSaldosBancosCC(RepSaldoBancosCCBean repSaldoBancosCCBean, int tipoLista){
		//Query con el Store Procedure
				String query = "call SALDOSBANCOSCCREP(?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	repSaldoBancosCCBean.getFecha(),									
										repSaldoBancosCCBean.getInstitucionID(),
										repSaldoBancosCCBean.getNumCtaInstit(),
										repSaldoBancosCCBean.getTipoRep(),
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSBANCOSCCREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepSaldoBancosCCBean repSaldoBancosCCBean= new RepSaldoBancosCCBean();		
						repSaldoBancosCCBean.setFechaMov(resultSet.getString("Fecha"));
						repSaldoBancosCCBean.setNumCtaInstit(resultSet.getString("CuentaBancaria"));
						repSaldoBancosCCBean.setCuentaContable(resultSet.getString("CuentaContable"));
						repSaldoBancosCCBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
						repSaldoBancosCCBean.setSaldoInicial(resultSet.getString("SaldoInicial"));
						repSaldoBancosCCBean.setCargos(resultSet.getString("Cargos"));						
						repSaldoBancosCCBean.setAbonos(resultSet.getString("Abonos"));					
						repSaldoBancosCCBean.setSaldoFinal(resultSet.getString("SaldoFinal"));
						
										
						return repSaldoBancosCCBean;				
					}
				});
				return matches;
	}
	
	
	//reporte de saldos de bancos Detallado
	public List listaSaldosBancosCCDetallado(RepSaldoBancosCCBean repSaldoBancosCCBean, int tipoLista){
		//Query con el Store Procedure
				String query = "call SALDOSBANCOSCCREP(?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	repSaldoBancosCCBean.getFecha(),									
										repSaldoBancosCCBean.getInstitucionID(),
										repSaldoBancosCCBean.getNumCtaInstit(),
										repSaldoBancosCCBean.getFormaRep(),
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSBANCOSCCREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepSaldoBancosCCBean repSaldoBancosCCBean= new RepSaldoBancosCCBean();		
						repSaldoBancosCCBean.setFechaMov(resultSet.getString("Fecha"));
						repSaldoBancosCCBean.setNumCtaInstit(resultSet.getString("CuentaBancaria"));
						repSaldoBancosCCBean.setCuentaContable(resultSet.getString("CuentaContable"));
						repSaldoBancosCCBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
						repSaldoBancosCCBean.setCargos(resultSet.getString("Cargos"));						
						repSaldoBancosCCBean.setAbonos(resultSet.getString("Abonos"));					
						
										
						return repSaldoBancosCCBean;				
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
