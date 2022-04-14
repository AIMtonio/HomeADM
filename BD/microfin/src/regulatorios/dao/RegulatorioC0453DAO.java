package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA2610Bean;
import regulatorios.bean.RegulatorioC0453Bean;
import herramientas.Utileria;
 

public class RegulatorioC0453DAO extends BaseDAO {

    public RegulatorioC0453DAO() {
        super();
    }
    
    /* ------------------------------------------------------------------------------------------
     * ------------------------------------------------------------------------------------------
     * CSV
     * 
     * */
    
    public List <RegulatorioC0453Bean> reporteRegulatorioC452Csv(final RegulatorioC0453Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGULATORIOC0453REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
                            Utileria.convierteEntero(bean.getAnio()),
                            Utileria.convierteEntero(bean.getMes()),
                            tipoReporte,
                            parametrosAuditoriaBean.getEmpresaID(),
                            parametrosAuditoriaBean.getUsuario(),
                            parametrosAuditoriaBean.getFecha(),
                            parametrosAuditoriaBean.getDireccionIP(),
                            "regulatorioC0452DAO.reporteRegulatorioC452Csv",
                            parametrosAuditoriaBean.getSucursal(),
                            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0453REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
            public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                
                RegulatorioC0453Bean beanResponse= new RegulatorioC0453Bean();
                beanResponse.setValor(resultSet.getString("Valor"));

                return beanResponse ;
            }
        });
        return matches;
    }

    
    
    /* ------------------------------------------------------------------------------------------
     * ------------------------------------------------------------------------------------------
     * SOFIPO
     * 
     * */
    
    public List <RegulatorioC0453Bean> reporteRegulatorioC0453Sofipo(final RegulatorioC0453Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGULATORIOC0453REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
                            Utileria.convierteEntero(bean.getAnio()),
                            Utileria.convierteEntero(bean.getMes()),
                            tipoReporte,
                            parametrosAuditoriaBean.getEmpresaID(),
                            parametrosAuditoriaBean.getUsuario(),
                            parametrosAuditoriaBean.getFecha(),
                            parametrosAuditoriaBean.getDireccionIP(),
                            "regulatorioC0452DAO.reporteRegulatorioA2610Sofipo",
                            parametrosAuditoriaBean.getSucursal(),
                            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0453REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {         public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                
            RegulatorioC0453Bean beanResponse= new RegulatorioC0453Bean();
            
            beanResponse.setPeriodo(resultSet.getString("Var_Periodo"));
            beanResponse.setClaveEntidad(resultSet.getString("Var_ClaveEntidad"));
            beanResponse.setReporte(resultSet.getString("Reporte"));
            beanResponse.setIdencreditoCNBV(resultSet.getString("IdenCreditoCNBV"));
           
            beanResponse.setTipoBaja(resultSet.getString("TipoBaja"));
            beanResponse.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
            beanResponse.setMontoPagadoTotal(resultSet.getString("MontoPagado"));
            beanResponse.setMontoCastigos(resultSet.getString("MontoCastigos"));
            beanResponse.setMontoCondonacion(resultSet.getString("MontoCondona"));
            beanResponse.setMontoQuitas(resultSet.getString("MontoQuita"));
            beanResponse.setMontoBonificaciones(resultSet.getString("MontoBonifica"));
            beanResponse.setMontoDescuentos(resultSet.getString("MontoDescuento"));
            beanResponse.setMontoBienRecibido(resultSet.getString("MontoDacion"));
            beanResponse.setMontoCancelado(resultSet.getString("MontoFueraB"));
            beanResponse.setEstimacionesPreventivas(resultSet.getString("EPRCCancel"));
            beanResponse.setEstimacionesAdicionales(resultSet.getString("EPRCAdiCancel"));
            
            
            return beanResponse ;
            }
        });
        return matches;
    }
    
    
}
