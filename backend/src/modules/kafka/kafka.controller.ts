import { Controller, Logger } from '@nestjs/common';
import { EventPattern, Payload, Ctx, KafkaContext } from '@nestjs/microservices';
import { KafkaTopic } from './kafka.service';

@Controller()
export class KafkaController {
  private readonly logger = new Logger(KafkaController.name);

  // ============================================
  // Blockchain Event Handlers
  // ============================================

  @EventPattern(KafkaTopic.BLOCKCHAIN_TRANSACTION)
  async handleBlockchainTransaction(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    const topic = context.getTopic();
    const partition = context.getPartition();
    const offset = context.getMessage().offset;

    this.logger.log(
      `Received blockchain transaction: topic=${topic}, partition=${partition}, offset=${offset}`,
    );

    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      this.logger.debug(`Transaction data: ${JSON.stringify(data)}`);
      
      // Process blockchain transaction
      // - Update local database
      // - Trigger notifications
      // - Update caches
    } catch (error) {
      this.logger.error(`Error processing blockchain transaction: ${error.message}`);
    }
  }

  @EventPattern(KafkaTopic.BLOCKCHAIN_CONTRACT_EVENT)
  async handleContractEvent(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    this.logger.log('Received contract event');
    
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Handle specific contract events
      switch (data.eventName) {
        case 'AkreditasiRegistered':
          await this.handleAkreditasiRegisteredEvent(data);
          break;
        case 'DocumentVerified':
          await this.handleDocumentVerifiedEvent(data);
          break;
        case 'AsesmenCompleted':
          await this.handleAsesmenCompletedEvent(data);
          break;
        default:
          this.logger.debug(`Unhandled contract event: ${data.eventName}`);
      }
    } catch (error) {
      this.logger.error(`Error processing contract event: ${error.message}`);
    }
  }

  // ============================================
  // Akreditasi Event Handlers
  // ============================================

  @EventPattern(KafkaTopic.AKREDITASI_STATUS_CHANGED)
  async handleAkreditasiStatusChanged(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    this.logger.log('Received akreditasi status change event');
    
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Notify relevant parties about status change
      // - Send email to institution
      // - Update dashboard
      // - Log to audit trail
      
      this.logger.log(
        `Akreditasi ${data.akreditasiId} status changed from ${data.oldStatus} to ${data.newStatus}`,
      );
    } catch (error) {
      this.logger.error(`Error processing status change: ${error.message}`);
    }
  }

  // ============================================
  // Document Event Handlers
  // ============================================

  @EventPattern(KafkaTopic.DOCUMENT_UPLOADED)
  async handleDocumentUploaded(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    this.logger.log('Received document uploaded event');
    
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Trigger document processing
      // - Store in IPFS
      // - Generate hash
      // - Register on blockchain
      
      this.logger.log(`Document ${data.documentId} uploaded by user ${data.uploadedBy}`);
    } catch (error) {
      this.logger.error(`Error processing document upload: ${error.message}`);
    }
  }

  @EventPattern(KafkaTopic.DOCUMENT_IPFS_STORED)
  async handleDocumentIpfsStored(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    this.logger.log('Received IPFS storage event');
    
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Update document record with IPFS hash
      // Register hash on blockchain for verification
      
      this.logger.log(`Document ${data.documentId} stored in IPFS: ${data.ipfsHash}`);
    } catch (error) {
      this.logger.error(`Error processing IPFS storage: ${error.message}`);
    }
  }

  // ============================================
  // Payment Event Handlers
  // ============================================

  @EventPattern(KafkaTopic.PAYMENT_COMPLETED)
  async handlePaymentCompleted(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    this.logger.log('Received payment completed event');
    
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Update akreditasi status
      // Send confirmation email
      // Generate receipt
      
      this.logger.log(
        `Payment ${data.paymentId} completed for akreditasi ${data.akreditasiId}`,
      );
    } catch (error) {
      this.logger.error(`Error processing payment completion: ${error.message}`);
    }
  }

  // ============================================
  // Audit Event Handlers
  // ============================================

  @EventPattern(KafkaTopic.AUDIT_LOG)
  async handleAuditLog(
    @Payload() message: any,
    @Ctx() context: KafkaContext,
  ) {
    try {
      const data = typeof message === 'string' ? JSON.parse(message) : message;
      
      // Store audit log to database
      // Forward to monitoring system
      
      this.logger.debug(
        `Audit: ${data.action} on ${data.entityType}:${data.entityId} by user ${data.userId}`,
      );
    } catch (error) {
      this.logger.error(`Error processing audit log: ${error.message}`);
    }
  }

  // ============================================
  // Private Helper Methods
  // ============================================

  private async handleAkreditasiRegisteredEvent(data: any) {
    this.logger.log(`Akreditasi registered on blockchain: ${JSON.stringify(data.args)}`);
    // Update local database with blockchain confirmation
  }

  private async handleDocumentVerifiedEvent(data: any) {
    this.logger.log(`Document verified on blockchain: ${JSON.stringify(data.args)}`);
    // Update document verification status
  }

  private async handleAsesmenCompletedEvent(data: any) {
    this.logger.log(`Asesmen completed on blockchain: ${JSON.stringify(data.args)}`);
    // Update asesmen status and trigger next workflow step
  }
}
