package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.exolab.castor.xml.handlers.ValueOfFieldHandler;
import org.springframework.jdbc.core.RowMapper;
 
import tesoreria.bean.RepDepositosRefBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;


public class RepDepositosRefDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean=null;

	public RepDepositosRefDAO () {
		super();
	}
	
	//reporte para reportes depositos referenciados
	public List consultaDepositosRef(RepDepositosRefBean reporteBean){
		//Query con el Store Procedure	
				String query = "call DEPOSITOSREFEREP(?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";		
				Object[] parametros = {										
										reporteBean.getFechaInicial(),
										reporteBean.getFechaFinal(),
										reporteBean.getInstitucionID(),
										reporteBean.getCuentaBancaria(),
										reporteBean.getClienteID(),
										reporteBean.getSucursalID(),
										reporteBean.getEstado(),
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOSREFEREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepDepositosRefBean repDepositosRefBean= new RepDepositosRefBean();			
						repDepositosRefBean.setClienteID(resultSet.getString("Cliente"));
						repDepositosRefBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						repDepositosRefBean.setReferencia(resultSet.getString("Referencia"));
						repDepositosRefBean.setTipoCarga(resultSet.getString("TipoCarga"));
						repDepositosRefBean.setTipoMovimiento(resultSet.getString("TipoMov"));
						repDepositosRefBean.setDescripcionMov(resultSet.getString("DescripcionMov"));
						repDepositosRefBean.setBanco(resultSet.getString("Banco"));
						repDepositosRefBean.setCuentaBancaria(resultSet.getString("CuentaBancaria"));
						repDepositosRefBean.setEstado(resultSet.getString("Estado"));
						repDepositosRefBean.setFechaCarga(resultSet.getString("FechaCarga"));
						repDepositosRefBean.setFechaAplicacion(resultSet.getString("FechaAplica"));
						repDepositosRefBean.setMonto(Double.valueOf(resultSet.getString("Monto")).doubleValue());
						repDepositosRefBean.setMontoAplicado(Double.valueOf(resultSet.getString("MontoAplicado")).doubleValue());
						repDepositosRefBean.setHoraEmision(resultSet.getString("HoraEmision"));
						repDepositosRefBean.setTipoDeposito(resultSet.getString("TipoDeposito"));
						return repDepositosRefBean;				
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






